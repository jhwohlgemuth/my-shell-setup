[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Position = 0)]
    [string[]]$Packages = @("nushell", "neovim", "starship", "agents")
)

$availablePackages = @("nushell", "neovim", "starship", "agents")
$selectedPackages = @(
    @(
        foreach ($argument in $Packages) {
            foreach ($package in $argument -split "[,\s]+") {
                if ($package) {
                    $package.ToLowerInvariant()
                }
            }
        }
    ) | Select-Object -Unique
)

if ($selectedPackages.Count -eq 0) {
    throw "At least one package name is required. Available packages: $($availablePackages -join ', ')"
}

$unknownPackages = @($selectedPackages | Where-Object { $_ -notin $availablePackages })
if ($unknownPackages.Count -gt 0) {
    throw "Unknown Windows package(s): $($unknownPackages -join ', '). Available packages: $($availablePackages -join ', ')"
}

foreach ($package in $selectedPackages) {
    switch ($package) {
        "nushell" {
            $destination = Join-Path $env:APPDATA "nushell"
            if ($PSCmdlet.ShouldProcess($destination, "Install Nushell configuration")) {
                New-Item -ItemType Directory -Force $destination | Out-Null
                Copy-Item "$PSScriptRoot\nushell\.config\nushell\*" $destination -Recurse -Force
            }
        }
        "neovim" {
            $destination = Join-Path $env:LOCALAPPDATA "nvim"
            if ($PSCmdlet.ShouldProcess($destination, "Install Neovim configuration")) {
                New-Item -ItemType Directory -Force $destination | Out-Null
                Copy-Item "$PSScriptRoot\neovim\.config\nvim\*" $destination -Recurse -Force
            }
        }
        "starship" {
            $destination = Join-Path $HOME ".config"
            if ($PSCmdlet.ShouldProcess($destination, "Install Starship configuration")) {
                New-Item -ItemType Directory -Force $destination | Out-Null
                Copy-Item "$PSScriptRoot\starship\.config\*" $destination -Recurse -Force
            }
        }
        "agents" {
            $source = Join-Path $PSScriptRoot "agents\.agents\skills"
            $destination = Join-Path $HOME ".agents\skills"
            if ($PSCmdlet.ShouldProcess($destination, "Install agent skills")) {
                if (-not (Test-Path -LiteralPath $source -PathType Container)) {
                    throw "Agent skills directory not found: $source"
                }
                # Match the runtime inventory in agents/scripts/check_stow.py and .stow-local-ignore.
                $runtimeDirectories = @("agents", "assets", "references", "scripts")
                $excludedParts = @(
                    ".git", ".gitignore", ".gitattributes", ".gitmodules", ".svn", ".hg",
                    ".DS_Store", "__pycache__", ".pytest_cache", ".mypy_cache",
                    ".ruff_cache", ".coverage"
                )
                foreach ($skill in Get-ChildItem -LiteralPath $source -Directory) {
                    $entrypoint = Join-Path $skill.FullName "SKILL.md"
                    if (-not (Test-Path -LiteralPath $entrypoint -PathType Leaf)) {
                        continue
                    }
                    $skillDestination = Join-Path $destination $skill.Name
                    New-Item -ItemType Directory -Force $skillDestination | Out-Null
                    Copy-Item -LiteralPath $entrypoint -Destination $skillDestination -Force
                    foreach ($directory in $runtimeDirectories) {
                        $runtimeSource = Join-Path $skill.FullName $directory
                        if (-not (Test-Path -LiteralPath $runtimeSource -PathType Container)) {
                            continue
                        }
                        foreach ($file in Get-ChildItem -LiteralPath $runtimeSource -Recurse -File -Force) {
                            $relativePath = $file.FullName.Substring($skill.FullName.Length + 1)
                            $parts = $relativePath -split '[\\/]'
                            if (@($parts | Where-Object { $_ -in $excludedParts }).Count -gt 0 -or
                                $file.Name -match '(\.py[co]|~)$|^\.\#|^\#.*\#$') {
                                continue
                            }
                            $target = Join-Path $skillDestination $relativePath
                            New-Item -ItemType Directory -Force (Split-Path -Parent $target) | Out-Null
                            Copy-Item -LiteralPath $file.FullName -Destination $target -Force
                        }
                    }
                }
            }
        }
    }
}
