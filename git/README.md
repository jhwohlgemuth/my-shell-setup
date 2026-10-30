# Git

This package installs the user Git configuration at `~/.gitconfig`.

It configures Delta as the pager, enables side-by-side diffs and moved-line coloring, uses `diff3` merge conflicts, requires fast-forward pulls, and adds `last` and `changed` aliases.

## Install

```shell
stow --dir "${HOME}/.dotfiles" --target "${HOME}" --stow git
```

Install [Delta](https://dandavison.github.io/delta/) to use the configured pager.
