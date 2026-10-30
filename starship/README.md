# Starship

This package installs the active Starship prompt at `~/.config/starship.toml` and a reusable default configuration at `~/.config/starship/default.toml`.

The prompt shows operating system, user, directory, Git state, command status, language runtimes, shell, and time using custom palettes and segmented styling.

## Install

```shell
stow --dir "${HOME}/.dotfiles" --target "${HOME}" --stow starship
```

Initialize Starship from your shell after installation. The Nushell package's `setup.nu` script generates its Nushell integration automatically.
