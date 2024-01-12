<#
.SYNOPSIS
Setup script for configuring Windows Terminal.
#>
[CmdletBinding(SupportsShouldProcess = $True)]
Param()
#
# Set script variables
#
$Root = $PSScriptRoot
$ConfigDirectory = Join-Path $Root 'config'
$ScriptsDirectory = Join-Path $Root 'scripts'
$LocalSettingsPath = "$Env:LocalAppData\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
$CmdletParameters = @{
    Verbose = $PSCmdlet.MyInvocation.BoundParameters['Verbose'].IsPresent -eq $True
    WhatIf = $PSCmdlet.MyInvocation.BoundParameters['WhatIf'].IsPresent -eq $True
}
#
# Copy windows terminal profile
#
"==> [INFO] Copying profile configuration to ${PROFILE}" | Write-Verbose
Set-Content -Path $PROFILE -Value (Get-Content -Path (Join-Path $ConfigDirectory 'Microsoft.Powershell_profile.ps1')) @CmdletParameters
#
# Copy windows terminal settings.json
#
"==> [INFO] Copying settings.json to ${LocalSettingsPath}" | Write-Verbose
Set-Content -Path $LocalSettingsPath -Value (Get-Content -Path (Join-Path $ConfigDirectory 'settings.json')) @CmdletParameters
#
# Copy custom oh-my-posh theme
#
"==> [INFO] Copying custom oh-my-posh theme to ${HOME}" | Write-Verbose
Set-Content -Path "${HOME}/.theme.omp.json" -Value (Get-Content -Path (Join-Path $ConfigDirectory '.theme.omp.json')) @CmdletParameters