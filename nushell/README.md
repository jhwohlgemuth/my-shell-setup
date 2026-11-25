# Nushell

This package installs the Nushell configuration under `~/.config/nushell`.

It provides environment and editor settings, SQLite history, fuzzy completions, abbreviations, key bindings, reusable Git, Docker, system, and theme modules, plus a repeatable post-Stow setup script.

## Install on Linux or macOS

```shell
stow --dir "${HOME}/.dotfiles" --target "${HOME}" --stow nushell
nu "${HOME}/.config/nushell/setup.nu"
```

The setup script registers available core plugins and generates Starship, Zoxide, and Atuin integration when those commands are installed. Atuin is written to Nushell's autoload directory because Nushell requires its generated integration at a static path. Optional tools are reported without making them mandatory.

## Install on Windows

Use the Windows bootstrap from the repository checkout:

```powershell
& ./install.ps1 -Packages nushell
```

Windows stores the installed files under `%APPDATA%\nushell`, which Nushell exposes as `$nu.default-config-dir`. Run the post-install setup from Nushell with:

```nu
nu ($nu.default-config-dir | path join "setup.nu")
```
