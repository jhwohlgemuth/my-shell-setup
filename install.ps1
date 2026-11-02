[CmdletBinding(SupportsShouldProcess)]
param(
    [Parameter(Position = 0)]
    [string[]]$Packages = @("nushell", "neovim", "starship", "agents")
)

# Keep this list in sync with Invoke-WindowsSetup.ps1 so invalid input fails before Git changes.
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

function Invoke-WindowsBootstrap {
    [CmdletBinding(SupportsShouldProcess)]
    param([string[]]$SelectedPackages)

    $repositoryUrl = "https://github.com/jhwohlgemuth/my-shell-setup.git"
    $checkout = if ($env:GOLD_DOTFILES) { $env:GOLD_DOTFILES } else { Join-Path $HOME ".dotfiles" }
    $checkout = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($checkout)
    $installer = Join-Path $checkout "Invoke-WindowsSetup.ps1"

    if (Test-Path -LiteralPath $checkout) {
        if (-not (Test-Path -LiteralPath (Join-Path $checkout ".git"))) {
            throw "Existing checkout is not a Git repository: $checkout"
        }
        if (-not (Get-Command -Name git -ErrorAction SilentlyContinue)) {
            throw "Git is required to verify the Windows package checkout."
        }
        $origin = (git -C $checkout remote get-url origin | Out-String).Trim()
        if ($LASTEXITCODE -ne 0 -or
            $origin -notmatch '^(https://github\.com/|git@github\.com:|ssh://git@github\.com/|ssh://git@ssh\.github\.com:443/)jhwohlgemuth/my-shell-setup(?:\.git)?/?$') {
            throw "Unexpected repository origin for Windows package checkout: $origin"
        }
        $branch = (git -C $checkout branch --show-current | Out-String).Trim()
        if ($LASTEXITCODE -ne 0 -or $branch -cne 'main') {
            throw "Windows package checkout must be on main; found: $branch"
        }
        if ($PSCmdlet.ShouldProcess($checkout, "Update my-shell-setup checkout")) {
            git -C $checkout pull --ff-only origin main
            if ($LASTEXITCODE -ne 0) {
                throw "Could not update my-shell-setup checkout: $checkout"
            }
        }
    } elseif ($PSCmdlet.ShouldProcess($checkout, "Clone my-shell-setup checkout")) {
        if (-not (Get-Command -Name git -ErrorAction SilentlyContinue)) {
            throw "Git is required to install Windows packages."
        }
        New-Item -ItemType Directory -Force (Split-Path -Parent $checkout) | Out-Null
        git clone --branch main --single-branch $repositoryUrl $checkout
        if ($LASTEXITCODE -ne 0) {
            throw "Could not clone my-shell-setup to $checkout"
        }
    } else {
        # Without a checkout, -WhatIf can preview the clone but cannot load its installer.
        return
    }

    if (-not (Test-Path -LiteralPath $installer -PathType Leaf)) {
        throw "Windows package installer not found in checkout: $installer"
    }
    $installerChanges = (git -C $checkout status --porcelain -- Invoke-WindowsSetup.ps1 | Out-String).Trim()
    if ($LASTEXITCODE -ne 0 -or $installerChanges) {
        throw "Windows package installer has local changes or could not be verified: $installer"
    }

    & $installer -Packages $SelectedPackages -WhatIf:$WhatIfPreference
}

Invoke-WindowsBootstrap -SelectedPackages $selectedPackages -WhatIf:$WhatIfPreference
