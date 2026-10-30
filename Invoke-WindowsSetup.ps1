[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Position = 0)]
    [string[]]$Packages = @("nushell", "neovim", "starship")
)

$availablePackages = @("nushell", "neovim", "starship")
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
    }
}
