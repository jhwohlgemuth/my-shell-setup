# PowerShell

This package contains the PowerShell profile at `~/.config/powershell/Microsoft.PowerShell_profile.ps1` and Windows Terminal settings in `settings.json`.

The profile configures PSReadLine, loads optional modules, adds Git and Docker shortcuts, enables completions and directory traversal helpers, and initializes Zoxide and Oh My Posh when available.

## Install

On Linux or macOS, Stow the PowerShell profile into the home directory:

```shell
stow --dir "${HOME}/.dotfiles" --target "${HOME}" --stow powershell
```

The repository's current `Invoke-WindowsSetup.ps1` does not install this package on Windows. Copy `Microsoft.PowerShell_profile.ps1` to the path reported by `$PROFILE` and import `settings.json` through Windows Terminal when configuring a native Windows machine.
