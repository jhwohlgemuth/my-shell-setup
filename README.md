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
> Install only selected packages by passing their names after `bash -s --`:
>
> ```bash
> curl -fsSL https://shell.jasonwohlgemuth.me/install.sh | bash -s -- git neovim agents
> ```
>
> Separate arguments are recommended. A comma-separated list also works:
>
> ```bash
> curl -fsSL https://shell.jasonwohlgemuth.me/install.sh | bash -s -- git,neovim,agents
> ```
>
> Package names must match directories listed under [Install packages](#install-packages). With no names, the installer uses its default package set.

On Windows, run this in PowerShell:

```powershell
irm https://shell.jasonwohlgemuth.me/install.ps1 | iex
```

To install only selected Windows packages, invoke the downloaded script with `-Packages`:

```powershell
& ([scriptblock]::Create((irm https://shell.jasonwohlgemuth.me/install.ps1))) -Packages nushell,starship
```

The Windows installer supports `nushell`, `neovim`, and `starship`; with no package names, it installs all three. Package names can be separate array values, comma-separated strings, or space-separated strings. The installer requires Git and clones the repository to `$HOME\.dotfiles` (or updates an existing clone). Set `$env:GOLD_DOTFILES` before running the command to use a different clone location.

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

| Package | Configuration |
| --- | --- |
| <img src="https://api.iconify.design/mdi/robot-outline.svg?color=%238a8a8a" width="20" height="20" alt="Agent skills logo"> [agents](./agents/README.md) | Personal AI agent skills installed into `~/.agents` — [`skills/`](./agents/.agents/skills)<br>Waza development and test workflow — [`README.md`](./agents/README.md) |
| <img src="https://cdn.simpleicons.org/clojure" width="20" height="20" alt="Clojure logo"> [clojure](./clojure/README.md) | [Leiningen](https://leiningen.org/) user profile, aliases, dependencies, and plugins — [`profiles.clj`](./clojure/.lein/profiles.clj) |
| <img src="https://cdn.simpleicons.org/elixir" width="20" height="20" alt="Elixir logo"> [elixir](./elixir/README.md) | [IEx](https://hexdocs.pm/iex/1.12/IEx.html) configuration — [`.iex.exs`](./elixir/.iex.exs) |
| <img src="https://cdn.simpleicons.org/git" width="20" height="20" alt="Git logo"> [git](./git/README.md) | Configures [Delta](https://github.com/dandavison/delta) and adds some useful aliases — [`.gitconfig`](./git/.gitconfig) |
| <img src="https://cdn.simpleicons.org/gnubash" width="20" height="20" alt="GNU Bash logo"> [gold](./gold/README.md) | Collection of utility functions and installation scripts. See the [Gold](https://github.com/jhwohlgemuth/gold) project for motivation and example usage. |
| <img src="https://raw.githubusercontent.com/modem-dev/hunk/main/assets/hunk-logo.webp" width="20" height="20" alt="Hunk logo"> [hunk](./hunk/README.md) | Review configuration — [`config.toml`](./hunk/.config/hunk/config.toml) |
| <img src="https://cdn.simpleicons.org/neovim" width="20" height="20" alt="Neovim logo"> [neovim](./neovim/README.md) | Usage and plugin guide — [README.md](./neovim/README.md)<br>Themes — [`themes/`](./neovim/.config/nvim/themes/)<br>Editor configuration — [`init.vim`](./neovim/.config/nvim/init.vim) and [`general/`](./neovim/.config/nvim/general/)<br>Plugin configuration — [`plug-config/`](./neovim/.config/nvim/plug-config/) |
| <img src="https://cdn.simpleicons.org/nushell" width="20" height="20" alt="Nushell logo"> [nushell](./nushell/README.md) | Shell configuration — [`config.nu`](./nushell/.config/nushell/config.nu) and [`env.nu`](./nushell/.config/nushell/env.nu)<br>Setup and reusable modules — [`setup.nu`](./nushell/.config/nushell/setup.nu) and [`modules/`](./nushell/.config/nushell/modules/) |
| <img src="https://cdn.simpleicons.org/ocaml" width="20" height="20" alt="OCaml logo"> [ocaml](./ocaml/README.md) | [utop](https://github.com/ocaml-community/utop) configuration — [`init.ml`](./ocaml/.config/utop/init.ml) and [`.utoprc`](./ocaml/.utoprc) |
| <img src="https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/website/static/img/logo-dark.svg#gh-light-mode-only" width="20" height="20" alt="Oh My Posh logo"><img src="https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/website/static/img/logo-light.svg#gh-dark-mode-only" width="20" height="20" alt="Oh My Posh logo"> [ohmyposh](./ohmyposh/README.md) | Theme — [`.theme.omp.json`](./ohmyposh/.theme.omp.json) |
| <img src="https://cdn.simpleicons.org/zsh" width="20" height="20" alt="Zsh logo"> [powerlevel10k](./powerlevel10k/README.md) | Configuration — [`.p10k.zsh`](./powerlevel10k/.p10k.zsh) |
| <img src="https://cdn.jsdelivr.net/gh/devicons/devicon@latest/icons/powershell/powershell-original.svg" width="20" height="20" alt="PowerShell logo"> [powershell](./powershell/README.md) | Profile — [`Microsoft.PowerShell_profile.ps1`](./powershell/.config/powershell/Microsoft.PowerShell_profile.ps1)<br>Settings — [`settings.json`](./powershell/settings.json) |
| <img src="https://cdn.simpleicons.org/starship" width="20" height="20" alt="Starship logo"> [starship](./starship/README.md) | Prompt configuration and default theme — [`starship.toml`](./starship/.config/starship.toml) and [`default.toml`](./starship/.config/starship/default.toml) |

### Agent skills

Install the agent skills into the home directory target used by the other packages. The package's `.agents/` directory maps to `~/.agents`:

```shell
stow --no-folding --dir "${HOME}/.dotfiles" --target "${HOME}" --stow agents
```

From the repository root, verify the Stow layout without changing your home directory, then use Waza for static checks, a credential-free mock test, or interactive development:

```shell
make help
make -C agents help
make -C agents stow-check
make -C agents check
make -C agents test
make -C agents dev
```

The included `blank-test` skill is a canary for skill discovery. Ask an agent to run the blank test skill after installation; a successful invocation returns `BLANK_TEST_SKILL_OK`.
Pass `AGENT_SKILL=<name>` to the Waza Make targets to develop another skill. See the [agent skills guide](./agents/README.md) for Waza installation and scaffolding.

To improve a skill, capture a real-agent assessment, inspect failures, make one focused change, and assess again. Repeat the same command for every revision; it saves numbered runs and compares each one with the previous completed run. Keep the imported Acorn instructions as the starting point:

```shell
make -C agents ci
make -C agents assess AGENT_SKILL=guidelines-rust AGENT_TRIALS=5
# Review the saved results, then edit the skill.
make -C agents assess AGENT_SKILL=guidelines-rust AGENT_TRIALS=5
```

The default history lives under `/tmp/my-shell-setup-waza-iterations`; set `AGENT_ITERATIONS_DIR` for durable storage. Each assessment also measures the skill against a no-skill control; set `AGENT_EFFECT=0` to skip that extra run. Real-agent runs require authenticated Copilot access and can incur model usage. See the [agent skills guide](./agents/README.md) for result paths and review steps.

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
