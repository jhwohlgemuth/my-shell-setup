My Shell Setup
==============
Configure [Windows Terminal](https://www.microsoft.com/store/productId/9N0DX20HK701) on Windows and [Oh My Posh](https://ohmyposh.dev/) on Linux and Mac.

<div align="center">
    <a href="#"><img alt="Windows Terminal in action!" src="http://www.jasonwohlgemuth.com/env/images/env_terminal_demo.gif" alt="So pretty!" width="1280"/></a>
</div>

Why?
----
This project codifies how I configure my development environment across Windows, Linux, and OSX, using Windows Terminal<sup>[1](#1)</sup>, Oh My Posh, Neovim, zsh, and oh-my-zsh.

Applications to Configure with [Stow](https://www.gnu.org/software/stow/)
-----------------------------------
```shell
git clone https://github.com/jhwohlgemuth/my-shell-setup
stow -d my-shell-setup -d ~ git powershell powerlevel10k neovim ohmyposh
```
### Application files
- Git
  - [`.gitconfig`](./git/.gitconfig) - Configures [Delta](https://github.com/dandavison/delta) and adds some useful aliases
- Powerlevel10K
  - [`.p10k.zsh`](./powerlevel10k/.p10k.zsh) - [powerlevel10k](https://github.com/romkatv/powerlevel10k) configuration file
- Powershell
  - [`Microsoft.Powershell_profile.ps1`](./powershell/.config/powershell/Microsoft.Powershell_profile.ps1) - Windows terminal profile file
  - [`settings.json`](./public/settings.json) - Windows terminal settings file
- Oh-my-posh
  - [`.theme.omp.json`](./ohmyposh/.theme.omp.json) - Oh My Posh theme file
- Neovim <sup>[2](#2)</sup>
    > [!TIP]
    > Turn your terminal into a full-fledged integrated development environment (IDE) using [Neovim](https://neovim.io/)

<div align="center">
    <a href="https://gyazo.com/57ccdc67266ee53eb6911a3a9b75be58"><img id="screenshot" alt="Neovim in action!" src="https://i.gyazo.com/57ccdc67266ee53eb6911a3a9b75be58.gif" width="750"/></a>
</div>

Install and Configure Neovim
----------------------------
### Install Neovim
#### Linux / Mac
- `brew install neovim`
- `spack install neovim`
### Windows
- `scoop install neovim`
- `choco install neovim`
- `winget install Neovim.Neovim`

### Configure Neovim
#### Linux / Mac
```shell
git clone https://github.com/jhwohlgemuth/my-neovim-setup.git "${HOME}/.config/nvim/"
```

##### Windows
```shell
git clone https://github.com/jhwohlgemuth/my-neovim-setup.git
cd my-neovim-setup
./Invoke-Setup.ps1
```


What Next?!
-----------
Now that you have an amazing shell, [try developing with containers!](https://github.com/jhwohlgemuth/env/tree/master/dev-with-containers)


-------------

**Footnotes**
-------------

[1]
---
> [Windows Terminal](https://www.microsoft.com/en-us/p/windows-terminal/9n0dx20hk701?activetab=pivot:overviewtab) is an [open source](https://github.com/microsoft/terminal) terminal for the modern developer. Combined with Powershell, anyone can easily enjoy a comfortable and truly robust developer experience on Windows. `#cantBelieveItsNotLinux`

[2]
---
> See [Neovim section](#install-and-configure-neovim) for more information on how to install and configure Neovim.
