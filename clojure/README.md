# Clojure

This package installs the user-level Leiningen profile at `~/.lein/profiles.clj`.

The profile adds aliases for REBL, linting, formatting, and fixes, plus development plugins for notebooks, dependency checks, code quality, coverage, and project scaffolding.

## Install

```shell
stow --dir "${HOME}/.dotfiles" --target "${HOME}" --stow clojure
```

Leiningen loads the profile automatically. Project profiles can extend or override these user defaults.
