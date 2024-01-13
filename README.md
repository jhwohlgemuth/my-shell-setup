My Shell Setup
==============
Configure [Windows Terminal](https://www.microsoft.com/store/productId/9N0DX20HK701) on Windows and [Oh My Posh](https://ohmyposh.dev/) on Linux and Mac.

<div align="center">
    <a href="#"><img alt="Windows Terminal in action!" src="http://www.jasonwohlgemuth.com/env/images/env_terminal_demo.gif" alt="So pretty!" width="1280"/></a>
</div>

Contents
--------
- [/config](./config/):
    - [`Applications.json`](./config/Applications.json) - JSON file listing all applications for various package managers that I use
    - [`Extensions.json`](./config/Extensions.json) - JSON file listing all VSCode extensions I use, grouped by associated language
    - [`Microsoft.Powershell_profile.ps1`](./config/Microsoft.Powershell_profile.ps1) - Windows terminal profile file
    - [`settings.json`](./config/settings.json) - Windows terminal settings file
    - [`.theme.omp.json`](./config/.theme.omp.json) - Oh My Posh theme file
- [/fonts](./fonts/) - Fonts for use with advanced shell themes
- [/scripts](./scripts/) - Powershell scripts for installing<sup>[2](#2)</sup> and configuring stuff

Why?
----
This project codifies how I configure my development environment across Windows, Linux, and OSX, using Windows Terminal<sup>[1](#1)</sup>, Oh My Posh, zsh, and oh-my-zsh.


What Next?!
-----------
Now that you have an amazing shell, [install Neovim](https://github.com/jhwohlgemuth/my-neovim-setup), and/or [try developing with containers!](https://github.com/jhwohlgemuth/env/tree/master/dev-with-containers)


-------------

**Footnotes**
-------------

[1]
---
> [Windows Terminal](https://www.microsoft.com/en-us/p/windows-terminal/9n0dx20hk701?activetab=pivot:overviewtab) is an [open source](https://github.com/microsoft/terminal) terminal for the modern developer. Combined with Powershell, anyone can easily enjoy a comfortable and truly robust developer experience on Windows. `#cantBelieveItsNotLinux`

[2]
---
> Depending on your system configuration, you may experience issues trying to execute [Invoke-Install.ps1](./scripts/Invoke-Install.ps1).
> For execution policy problems, you can bypass the policy one time with

```
Set-ExecutionPolicy Bypass -Scope Process -Force; ./scripts/Invoke-Install.ps1
```