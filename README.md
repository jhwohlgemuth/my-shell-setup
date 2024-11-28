My Shell Setup
==============
Configure [Windows Terminal](https://www.microsoft.com/store/productId/9N0DX20HK701) on Windows and [Oh My Posh](https://ohmyposh.dev/) on Linux and Mac.

<div align="center">
    <a href="#"><img alt="Windows Terminal in action!" src="http://www.jasonwohlgemuth.com/env/images/env_terminal_demo.gif" alt="So pretty!" width="1280"/></a>
</div>

Why?
----
This project codifies how I configure my development environment across Windows, Linux, and OSX, using Windows Terminal<sup>[1](#1)</sup>, Oh My Posh, Neovim, zsh, and oh-my-zsh.

Configure with [Stow](https://www.gnu.org/software/stow/)
-----------------------------------
```shell
git clone https://github.com/jhwohlgemuth/my-shell-setup
stow --dir "${HOME}/.dotfiles" --target "${HOME}" --stow git neovim ohmyposh powerlevel10k powershell
```
### Applications
- git
  - [`.gitconfig`](./git/.gitconfig) - Configures [Delta](https://github.com/dandavison/delta) and adds some useful aliases
- neovim
  - Editor configuration - [init.vim](./neovim/.config/nvim/init.vim) and [general/](./neovim/.config/nvim/general/)
  - Themes - [themes/](./neovim/.config/nvim/themes/)
  - Plugin configurations - [plug-config/](./neovim/.config/nvim/plug-config/)
- powerlevel10k
  - [`.p10k.zsh`](./powerlevel10k/.p10k.zsh) - [powerlevel10k](https://github.com/romkatv/powerlevel10k) configuration file
- powershell
  - [`Microsoft.Powershell_profile.ps1`](./powershell/.config/powershell/Microsoft.Powershell_profile.ps1) - Windows terminal profile file
  - [`settings.json`](./public/settings.json) - Windows terminal settings file
- ohmyposh
  - [`.theme.omp.json`](./ohmyposh/.theme.omp.json) - Oh My Posh theme file

### Example Neovim configuration
<div align="center">
    <a href="https://gyazo.com/57ccdc67266ee53eb6911a3a9b75be58"><img id="screenshot" alt="Neovim in action!" src="https://i.gyazo.com/57ccdc67266ee53eb6911a3a9b75be58.gif" width="750"/></a>
</div>

What Next?!
-----------
Now that you have an amazing shell, [try developing with containers!](https://github.com/jhwohlgemuth/gold)

-------------

**Footnotes**
-------------

[1]
---
> [Windows Terminal](https://www.microsoft.com/en-us/p/windows-terminal/9n0dx20hk701?activetab=pivot:overviewtab) is an [open source](https://github.com/microsoft/terminal) terminal for the modern developer. Combined with Powershell, anyone can easily enjoy a comfortable and truly robust developer experience on Windows. `#cantBelieveItsNotLinux`
