🐚 My Shell Setup
=================
This project codifies how I configure my development environment across Windows, Linux, and OSX, using Windows Terminal<sup>[1](#1)</sup>, Powerlevel10k<sup>[2](#2)</sup>, Neovim<sup>[3](#3)</sup>, and more.

🚀 Quick Start
--------------
Run this in a Linux or macOS terminal:

```bash
curl -fsSL https://shell.jasonwohlgemuth.me/install.sh | bash
```

> [!TIP]
> You can also pass package names to the script with `curl -fsSL https://shell.jasonwohlgemuth.me/install.sh | bash -s -- <packages>` where the list of packages can include any listed in the [install packages](#install-packages) section

On Windows, run this in PowerShell:

```powershell
irm https://shell.jasonwohlgemuth.me/install.ps1 | iex
```

The Windows installer requires Git. It clones the repository to `$HOME\.dotfiles` (or updates an existing clone), then installs the Nushell, Neovim, and Starship configuration. Set `$env:GOLD_DOTFILES` before running the command to use a different clone location.

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
- clojure
  - [Leiningen](https://leiningen.org/) user profile, aliases, dependencies, and plugins - [`profiles.clj`](./clojure/.lein/profiles.clj)
- elixir
  - [IEx](https://hexdocs.pm/iex/1.12/IEx.html) configuration - [`.iex.exs`](./elixir/.iex.exs)
- git
  - Configures [Delta](https://github.com/dandavison/delta) and adds some useful aliases - [`.gitconfig`](./git/.gitconfig)
- gold
  - Collection of utility functions and installation scripts. See the [Gold](https://github.com/jhwohlgemuth/gold) project for motivation and example usage.
- hunk
  - Review configuration - [`config.toml`](./hunk/.config/hunk/config.toml)
- neovim
  - Usage and plugin guide - [README.md](./neovim/README.md)
  - Themes - [`themes/`](./neovim/.config/nvim/themes/)
  - Editor configuration - [`init.vim`](./neovim/.config/nvim/init.vim) and [`general/`](./neovim/.config/nvim/general/)
  - Plugin configuration - [`plug-config/`](./neovim/.config/nvim/plug-config/)
- nushell
  - Shell configuration - [`config.nu`](./nushell/.config/nushell/config.nu) and [`env.nu`](./nushell/.config/nushell/env.nu)
  - Setup and reusable modules - [`setup.nu`](./nushell/.config/nushell/setup.nu) and [`modules/`](./nushell/.config/nushell/modules/)
- ocaml
  - [utop](https://github.com/ocaml-community/utop) configuration - [`init.ml`](./ocaml/.config/utop/init.ml) and [`.utoprc`](./ocaml/.utoprc)
- ohmyposh
  - Theme - [`.theme.omp.json`](./ohmyposh/.theme.omp.json)
- powerlevel10k
  - Configuration - [`.p10k.zsh`](./powerlevel10k/.p10k.zsh)
- powershell
  - Profile - [`Microsoft.PowerShell_profile.ps1`](./powershell/.config/powershell/Microsoft.PowerShell_profile.ps1)
  - Settings - [`settings.json`](./powershell/settings.json)
- starship
  - Prompt configuration and default theme - [`starship.toml`](./starship/.config/starship.toml) and [`default.toml`](./starship/.config/starship/default.toml)

### Remove packages
```shell
stow --delete <package names> --target <target>
```

### Docker rootless install
The `gold/install_docker` script now supports configuring Docker rootless mode for a non-root user.

- `ROOTLESS_USER`: Target Linux user for rootless Docker setup. Defaults to `nonroot` when omitted.
- `ROOTLESS_ONLY`: Defaults to `1` (rootless/client components only). Set to `0` to also install and start rootful Docker (`docker.service`).

Examples:
```shell
# Install rootless/client components only (default behavior)
ROOTLESS_USER=jason ./gold/install_docker

# Install rootful Docker and also configure rootless mode for user jason
ROOTLESS_USER=jason ROOTLESS_ONLY=0 ./gold/install_docker
```

After setup, use the rootless socket for that user session:
```shell
export DOCKER_HOST=unix:///run/user/$(id -u)/docker.sock
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
