[CmdletBinding()]
param(
    [string]$Directory = $(
        if ($env:GOLD_DOTFILES) {
            $env:GOLD_DOTFILES
        }
        else {
            Join-Path $HOME ".dotfiles"
        }
    )
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$repository = "https://github.com/jhwohlgemuth/my-shell-setup.git"

if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    throw "Git is required to install these dotfiles."
}

if (Test-Path -LiteralPath $Directory -PathType Container) {
    if (-not (Test-Path -LiteralPath (Join-Path $Directory ".git") -PathType Container)) {
        throw "The install directory exists but is not a Git repository: $Directory"
    }

    & git -C $Directory pull origin main
}
else {
    & git clone $repository $Directory
}

if ($LASTEXITCODE -ne 0) {
    throw "Unable to clone or update the dotfiles repository."
}

$setupScript = Join-Path $Directory "Invoke-WindowsSetup.ps1"
if (-not (Test-Path -LiteralPath $setupScript -PathType Leaf)) {
    throw "Windows setup script not found: $setupScript"
}

& $setupScript

Write-Host "==> Installation COMPLETE" -ForegroundColor Yellow
