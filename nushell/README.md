# Nushell

This package installs the Nushell configuration under `~/.config/nushell`.

It provides environment and editor settings, SQLite history, fuzzy completions, abbreviations, key bindings, reusable Git, Docker, system, and theme modules, plus a repeatable post-Stow setup script.

## Install

```shell
stow --dir "${HOME}/.dotfiles" --target "${HOME}" --stow nushell
nu "${HOME}/.config/nushell/setup.nu"
```

The setup script registers available core plugins and generates Starship and Zoxide integration when those commands are installed. Optional tools are reported without making them mandatory.
