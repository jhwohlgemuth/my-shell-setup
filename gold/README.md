# Gold utilities

This package installs the repository's executable utility and installer scripts directly into the selected target directory.

The scripts cover dependency checks, downloads, language and verification tools, containers, notebooks, editors, and local services. Installation scripts generally use the `install_` prefix; service launchers use `start_`; reusable helpers include `requires`, `is_command`, and `is_installed`.

## Install

To put the commands directly on a user-local path:

```shell
mkdir -p "${HOME}/.local/bin"
stow --dir "${HOME}/.dotfiles" --target "${HOME}/.local/bin" --stow gold
```

Ensure `~/.local/bin` is on `PATH`. Individual installers may require elevated privileges, containers, or platform-specific package managers; inspect a script before running it.

## Development

Format and lint the scripts from the repository root:

```shell
make format
```
