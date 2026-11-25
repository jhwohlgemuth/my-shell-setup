[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Position = 0)]
    [string[]]$Packages = @("atuin", "nushell", "neovim", "powershell", "starship", "agents")
)

$availablePackages = @("atuin", "nushell", "neovim", "powershell", "starship", "agents")
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

function Write-Utf8NoBom {
    param(
        [Parameter(Mandatory)]
        [string]$Path,
        [Parameter(Mandatory)]
        [AllowEmptyString()]
        [string]$Content
    )

    [IO.File]::WriteAllText($Path, $Content, [Text.UTF8Encoding]::new($false))
}

function Install-PowerShellProfileLoader {
    param(
        [Parameter(Mandatory)]
        [string]$ProfilePath,
        [Parameter(Mandatory)]
        [string]$ManagedProfile
    )

    $loader = ". `"$ManagedProfile`""
    $managedBlock = @(
        "# >>> my-shell-setup >>>"
        $loader
        "# <<< my-shell-setup <<<"
    ) -join [Environment]::NewLine

    New-Item -ItemType Directory -Force (Split-Path -Parent $ProfilePath) | Out-Null
    if (-not (Test-Path -LiteralPath $ProfilePath)) {
        Write-Utf8NoBom -Path $ProfilePath -Content "$managedBlock$([Environment]::NewLine)"
        return
    }

    $existing = Get-Content -LiteralPath $ProfilePath -Raw
    $isLegacyManagedProfile =
        $existing -match 'function\s+Invoke-GitCommand' -and
        $existing -match '#\s*Initialize oh-my-posh'

    if ($isLegacyManagedProfile) {
        $backup = "$ProfilePath.pre-my-shell-setup.bak"
        if (-not (Test-Path -LiteralPath $backup)) {
            Copy-Item -LiteralPath $ProfilePath -Destination $backup
            Write-Host "Backed up the legacy PowerShell profile to $backup"
        }
        Write-Utf8NoBom -Path $ProfilePath -Content "$managedBlock$([Environment]::NewLine)"
        Write-Host "Replaced the legacy copied profile with the My Shell Setup loader."
        return
    }

    if ($existing -notmatch [regex]::Escape($loader)) {
        $separator = if ($existing.Length -eq 0 -or $existing.EndsWith("`n")) { "" } else { [Environment]::NewLine }
        Write-Utf8NoBom -Path $ProfilePath -Content "$existing$separator$managedBlock$([Environment]::NewLine)"
    }
}

function Write-AtuinNushellInit {
    param(
        [Parameter(Mandatory)]
        [System.Management.Automation.CommandInfo]$AtuinCommand,
        [Parameter(Mandatory)]
        [string]$Destination
    )

    $content = (& $AtuinCommand.Source init nu --disable-up-arrow | Out-String)
    $exitCode = $LASTEXITCODE
    if ($exitCode -ne 0) {
        throw "Atuin failed to generate its Nushell integration (exit code $exitCode). The existing file was preserved."
    }
    if ([string]::IsNullOrWhiteSpace($content)) {
        throw "Atuin generated an empty Nushell integration. The existing file was preserved."
    }

    $temporary = "$Destination.$([Guid]::NewGuid().ToString('N')).tmp"
    try {
        Write-Utf8NoBom -Path $temporary -Content $content
        if (Test-Path -LiteralPath $Destination) {
            [IO.File]::Replace($temporary, $Destination, $null)
        }
        else {
            [IO.File]::Move($temporary, $Destination)
        }
    }
    finally {
        if (Test-Path -LiteralPath $temporary) {
            Remove-Item -LiteralPath $temporary -Force
        }
    }
}

foreach ($package in $selectedPackages) {
    switch ($package) {
        "atuin" {
            $source = Join-Path $PSScriptRoot "atuin\.config\atuin"
            $sharedDestination = Join-Path $HOME ".config\atuin"
            $atuinHome = Join-Path $HOME ".atuin"
            $config = Join-Path $atuinHome "config.toml"
            $template = Join-Path $source "config.toml.template"
            if ($PSCmdlet.ShouldProcess($sharedDestination, "Install Atuin configuration template and shell fragments")) {
                New-Item -ItemType Directory -Force $sharedDestination | Out-Null
                Copy-Item "$source\*" $sharedDestination -Recurse -Force
            }
            if (-not (Test-Path -LiteralPath $config) -and
                $PSCmdlet.ShouldProcess($config, "Create machine-local Atuin configuration")) {
                New-Item -ItemType Directory -Force $atuinHome | Out-Null
                Copy-Item -LiteralPath $template -Destination $config
            }
            elseif (Test-Path -LiteralPath $config) {
                Write-Warning "Preserved existing Atuin config: $config. Ensure it contains '[search]' with 'shells = `"all`"' for cross-shell search."
            }
            $atuinCommand = Get-Command -Name atuin -CommandType Application -ErrorAction SilentlyContinue | Select-Object -First 1
            if (-not $atuinCommand) {
                Write-Warning "Atuin is not installed; configuration is ready for the binary."
            }
        }
        "nushell" {
            $destination = Join-Path $env:APPDATA "nushell"
            if ($PSCmdlet.ShouldProcess($destination, "Install Nushell configuration")) {
                New-Item -ItemType Directory -Force $destination | Out-Null
                Copy-Item "$PSScriptRoot\nushell\.config\nushell\*" $destination -Recurse -Force
            }
        }
        "powershell" {
            $source = Join-Path $PSScriptRoot "powershell\.config\powershell"
            $destination = Join-Path $HOME ".config\powershell"
            if ($PSCmdlet.ShouldProcess($destination, "Install PowerShell configuration")) {
                New-Item -ItemType Directory -Force $destination | Out-Null
                Copy-Item "$source\*" $destination -Recurse -Force
            }

            $managedProfile = Join-Path $destination "Microsoft.PowerShell_profile.ps1"
            $documents = [Environment]::GetFolderPath([Environment+SpecialFolder]::MyDocuments)
            $profilePaths = @(
                (Join-Path $documents "PowerShell\Microsoft.PowerShell_profile.ps1"),
                (Join-Path $documents "WindowsPowerShell\Microsoft.PowerShell_profile.ps1")
            )
            foreach ($profilePath in $profilePaths) {
                if ($PSCmdlet.ShouldProcess($profilePath, "Add My Shell Setup PowerShell profile loader")) {
                    Install-PowerShellProfileLoader -ProfilePath $profilePath -ManagedProfile $managedProfile
                }
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

# Generate this after all package copies so selection order does not matter.
if ("atuin" -in $selectedPackages -or "nushell" -in $selectedPackages) {
    $atuinCommand = Get-Command -Name atuin -CommandType Application -ErrorAction SilentlyContinue | Select-Object -First 1
    $nushellConfig = Join-Path $env:APPDATA "nushell"
    if ($atuinCommand -and (Test-Path -LiteralPath $nushellConfig -PathType Container)) {
        $autoload = Join-Path $nushellConfig "autoload"
        $atuinInit = Join-Path $autoload "atuin.nu"
        if ($PSCmdlet.ShouldProcess($atuinInit, "Generate Atuin integration for Nushell")) {
            New-Item -ItemType Directory -Force $autoload | Out-Null
            Write-AtuinNushellInit -AtuinCommand $atuinCommand -Destination $atuinInit
        }
    }
}
