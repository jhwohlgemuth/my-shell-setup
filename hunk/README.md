# Hunk

This package installs Hunk's configuration at `~/.config/hunk/config.toml`.

The configuration selects the One Dark Pro theme, enables Git watching, line numbers, and the menu bar, and keeps untracked files visible during review.

## Install

```shell
stow --dir "${HOME}/.dotfiles" --target "${HOME}" --stow hunk
```

Start Hunk inside a Git repository to use the configuration.
