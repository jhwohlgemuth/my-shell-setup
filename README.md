My Shell Setup
==============
> `#cantBelieveItsNotLinux`

Configure [Windows Terminal](https://www.microsoft.com/store/productId/9N0DX20HK701) on Windows and [Oh My Posh](https://ohmyposh.dev/) on Linux and Mac.

<div align="center">
    <a href="#"><img alt="Windows Terminal in action!" src="http://www.jasonwohlgemuth.com/env/images/env_terminal_demo.gif" alt="So pretty!" width="1280"/></a>
</div>

What Next?!
-----------
Now that you have an amazing terminal, [install Neovim](https://github.com/jhwohlgemuth/my-neovim-setup), and/or [try developing with containers!](https://github.com/jhwohlgemuth/env/tree/master/dev-with-containers)


-------------

**Footnotes**
-------------

[1]
---
> Depending on your system configuration, you may experience issues trying to execute [Invoke-Install.ps1](./scripts/Invoke-Install.ps1).
> For execution policy problems, you can bypass the policy one time with

```
Set-ExecutionPolicy Bypass -Scope Process -Force; ./scripts/Invoke-Install.ps1
```