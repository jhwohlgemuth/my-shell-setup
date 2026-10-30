# Oh My Posh

This package installs the custom Oh My Posh theme at `~/.theme.omp.json`.

The theme displays operating system, session, path, Git state, execution time, privilege, runtime, and status information with the repository's color palette.

## Install

```shell
stow --dir "${HOME}/.dotfiles" --target "${HOME}" --stow ohmyposh
```

The PowerShell package loads this theme automatically when `oh-my-posh` is available. Other shells can pass the installed path to their normal Oh My Posh initialization command.
