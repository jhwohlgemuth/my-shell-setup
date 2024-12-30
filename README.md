🐚 My Shell Setup
=================
This project codifies how I configure my development environment across Windows, Linux, and OSX, using Windows Terminal<sup>[1](#1)</sup>, Powerlevel10k<sup>[2](#2)</sup>, Neovim<sup>[3](#3)</sup>, and more.

🚀 Quick Start
--------------
Run this in a Linux (or Mac) terminal
```bash
curl -fsSL https://shell.jasonwohlgemuth.me/install.sh | bash
```

> [!TIP]
> You can also pass package names to the script with `curl -fsSL https://shell.jasonwohlgemuth.me/install.sh | bash -s -- <packages>` where the list of packages can include any listed in the [install packages](#install-packages) section

🤓 Manual Setup
------------
### Make sure you have these things
- [Git](https://git-scm.com/) - easiest way to get the files within this project
- [Stow](https://www.gnu.org/software/stow/) - primary technology for configuration

> [!TIP]
> For a given application configuration to be useful, the associated software must be installed

### Clone this project
```shell
git clone https://github.com/jhwohlgemuth/my-shell-setup "${HOME}/.dotfiles"
```
### Install packages
```shell
stow --dir "${HOME}/.dotfiles" --target "${HOME}" --stow git neovim ohmyposh powerlevel10k powershell
```
- elixir
  - [IEx](https://hexdocs.pm/iex/1.12/IEx.html) configuration - [`.iex.exs`](./elixir/.iex.exs)
- git
  - Configures [Delta](https://github.com/dandavison/delta) and adds some useful aliases - [`.gitconfig`](./git/.gitconfig)
- gold
  - Collection of utility functions and installation scripts. See the [Gold](https://github.com/jhwohlgemuth/gold) project for motivation and example usage.
- neovim
  - Themes - [`themes/`](./neovim/.config/nvim/themes/)
  - Editor configuration - [`init.vim`](./neovim/.config/nvim/init.vim) and [`general/`](./neovim/.config/nvim/general/)
  - Plugin configuration - [`plug-config/`](./neovim/.config/nvim/plug-config/)
- ocaml
  - [utop](https://github.com/ocaml-community/utop) configuration - [`init.ml`](./ocaml/.config/utop/init.ml) and [`.utoprc`](./ocaml/.utoprc)
- ohmyposh
  - Theme - [`.theme.omp.json`](./ohmyposh/.theme.omp.json)
- powerlevel10k 
  - Configuration - [`.p10k.zsh`](./powerlevel10k/.p10k.zsh)
- powershell
  - Profile - [`Microsoft.Powershell_profile.ps1`](./powershell/.config/powershell/Microsoft.Powershell_profile.ps1)
  - Settings - [`settings.json`](./public/settings.json)

### Remove packages
```shell
stow --delete <package names> --target <target>
```

### Update packages
```shell
cd "${HOME}/.dotfiles"
git pull origin main
stow --target <target> --restow <package>
```

🔮 What Next?!
--------------
[Add or improve some packages](./CONTRIBUTING.md) and/or [try developing with containers!](https://github.com/jhwohlgemuth/gold)

-------------

**Footnotes**
-------------

1
---
> [Windows Terminal](https://www.microsoft.com/en-us/p/windows-terminal/9n0dx20hk701?activetab=pivot:overviewtab) is an [open source](https://github.com/microsoft/terminal) terminal for the modern developer. Combined with Powershell, anyone can easily enjoy a comfortable and truly robust developer experience on Windows. `#cantBelieveItsNotLinux`

2
---
[powerlevel10k](https://github.com/romkatv/powerlevel10k) is a theme for Zsh

3
---
Example Neovim configuration
<div align="center">
    <a href="https://gyazo.com/57ccdc67266ee53eb6911a3a9b75be58"><img id="screenshot" alt="Neovim in action!" src="https://i.gyazo.com/57ccdc67266ee53eb6911a3a9b75be58.gif" width="750"/></a>
</div>