[CmdletBinding(SupportsShouldProcess)]
param()

$nuConfig = Join-Path $env:APPDATA "nushell"
$nvimConfig = Join-Path $env:LOCALAPPDATA "nvim"
$starshipConfig = Join-Path $HOME ".config"

if ($PSCmdlet.ShouldProcess($nuConfig, "Install Nushell configuration")) {
    New-Item -ItemType Directory -Force $nuConfig | Out-Null
    Copy-Item "$PSScriptRoot\nushell\.config\nushell\*" $nuConfig -Recurse -Force
}

if ($PSCmdlet.ShouldProcess($nvimConfig, "Install Neovim configuration")) {
    New-Item -ItemType Directory -Force $nvimConfig | Out-Null
    Copy-Item "$PSScriptRoot\neovim\.config\nvim\*" $nvimConfig -Recurse -Force
}

if ($PSCmdlet.ShouldProcess($starshipConfig, "Install Starship configuration")) {
    New-Item -ItemType Directory -Force $starshipConfig | Out-Null
    Copy-Item "$PSScriptRoot\starship\.config\*" $starshipConfig -Recurse -Force
}
