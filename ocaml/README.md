# OCaml

This package installs UTop configuration at `~/.config/utop/init.ml` and `~/.utoprc`.

It defines a compact colored prompt and a dark terminal color profile for OCaml identifiers, modules, comments, constants, keywords, strings, errors, and directives.

## Install

```shell
stow --dir "${HOME}/.dotfiles" --target "${HOME}" --stow ocaml
```

Start `utop` to load both files.
