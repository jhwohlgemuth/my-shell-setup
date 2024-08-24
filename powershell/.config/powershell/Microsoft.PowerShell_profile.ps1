[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingInvokeExpression', '')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('RequireDirective', '')]
Param()
#
# Import Powershell modules
#
function Test-Installed {
    Param(
        [Parameter(Mandatory = $True, Position = 0)]
        [String] $Name
    )
    Get-Module -ListAvailable -Name $Name
}
if (Test-Installed PSReadLine) {
    Import-Module PSReadLine
    Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
    Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
    Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
}
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
$Modules = @(
    'PSScriptAnalyzer'
    'posh-git'
    'Terminal-Icons'
    'Prelude'
)
foreach ($Module in $Modules) {
    if (Test-Installed $Module) {
        Import-Module -Name $Module
    }
}
#
# Set aliases
#
Set-Alias -Scope Global -Option AllScope -Name ls -Value Get-ChildItem
if (Test-Command -Name git) {
    function Invoke-GitCommand { git $Args }
    function Invoke-GitCommit { git commit -vam $Args }
    function Invoke-GitDiff { git diff $Args }
    function Invoke-GitPushMaster { git push origin master }
    function Invoke-GitStatus { git status -sb }
    function Invoke-GitRebase { git rebase -i $Args }
    function Invoke-GitCheckout {
        Param(
            [Parameter(Position = 0)]
            [String] $File = '.'
        )
        git checkout -- $File
    }
    function Invoke-GitLog { git log --oneline --decorate }
    Set-Alias -Scope Global -Option AllScope -Name g -Value Invoke-GitCommand
    Set-Alias -Scope Global -Option AllScope -Name gcam -Value Invoke-GitCommit
    Set-Alias -Scope Global -Option AllScope -Name gd -Value Invoke-GitDiff
    Set-Alias -Scope Global -Option AllScope -Name glo -Value Invoke-GitLog
    Set-Alias -Scope Global -Option AllScope -Name gpom -Value Invoke-GitPushMaster
    Set-Alias -Scope Global -Option AllScope -Name grbi -Value Invoke-GitRebase
    Set-Alias -Scope Global -Option AllScope -Name gsb -Value Invoke-GitStatus
    Set-Alias -Scope Global -Option AllScope -Name gco -Value Invoke-GitCheckout
}
if (Test-Command -Name docker) {
    if (Test-Installed DockerCompletion) {
        Import-Module -Name DockerCompletion
    }
    $Format = 'table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}'
    function Invoke-DockerProcess { docker ps --format $Format }
    function Invoke-DockerProcessAll { docker ps -a --format $Format }
    function Invoke-DockerInspectAddress { docker inspect --format '{{ .NetworkSettings.IPAddress }}' $Args[0] }
    function Invoke-DockerRemoveAll { docker stop $(docker ps -a -q); docker rm --force $(docker ps -a -q) }
    function Invoke-DockerRemoveAllImage { docker rmi --force $(docker images -a -q) }
    Set-Alias -Scope Global -Option AllScope -Name dps -Value Invoke-DockerProcess
    Set-Alias -Scope Global -Option AllScope -Name dpa -Value Invoke-DockerProcessAll
    Set-Alias -Scope Global -Option AllScope -Name dip -Value Invoke-DockerInspectAddress
    Set-Alias -Scope Global -Option AllScope -Name dra -Value Invoke-DockerRemoveAll
    Set-Alias -Scope Global -Option AllScope -Name dri -Value Invoke-DockerRemoveAllImage
}
#
# Zoxide setup
#
if (Test-Command -Name zoxide) {
    Invoke-Expression (& { (zoxide init powershell | Out-String) })
}
#
# Create directory traversal shortcuts
#
for ($Index = 1; $Index -le 5; $Index++) {
    $Up = ''.PadLeft($Index, 'u')
    $Location = $Up.Replace('u', '../')
    Invoke-Expression "function ${Up} { push-location ${Location} }"
}
#
# Import Chocolatey profile
#
$ChocolateyProfile = "$Env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path $ChocolateyProfile) {
    Import-Module -Name $ChocolateyProfile
}
#
# Initialize oh-my-posh and set custom theme
#
if (Test-Command -Name 'oh-my-posh') {
    oh-my-posh init pwsh --config ~/.theme.omp.json | Invoke-Expression
}