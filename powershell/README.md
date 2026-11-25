# PowerShell

This package contains the PowerShell profile at `~/.config/powershell/Microsoft.PowerShell_profile.ps1` and Windows Terminal settings in `settings.json`.

The profile configures PSReadLine, loads optional modules, adds Git and Docker shortcuts, enables completions and directory traversal helpers, and initializes Atuin, Zoxide, and Oh My Posh when available. Atuin owns `Ctrl+R`; PSReadLine retains the Up/Down history search bindings.

## Install

On Linux or macOS, Stow the PowerShell profile into the home directory:

```shell
stow --dir "${HOME}/.dotfiles" --target "${HOME}" --stow powershell
```

On Windows, select the package through the bootstrap:

```powershell
& ./install.ps1 -Packages powershell
```

The installer copies the managed profile under `~/.config/powershell` and adds a marked dot-source loader to the PowerShell 7 and Windows PowerShell profile files. Unrelated profile content is preserved.

Older My Shell Setup releases copied the full managed profile into those native profile locations. When that legacy profile is detected, the installer replaces it with the loader so commands and prompt integrations do not initialize twice. The original is retained beside it as `Microsoft.PowerShell_profile.ps1.pre-my-shell-setup.bak` for manual recovery of any custom additions.

Import `settings.json` through Windows Terminal when configuring a native Windows machine.
