# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Overview

This repository contains cross-platform shell configuration and development environment setup using GNU Stow for dotfile management. It supports Windows (PowerShell), Linux (Bash/Zsh), and macOS.

**Key Architecture Concept**: This is a **Stow-based dotfiles repository** where each top-level directory (e.g., `git`, `powershell`, `neovim`) represents a "package" that can be independently installed using GNU Stow. Stow creates symlinks from the package directory to the target location (typically `$HOME`), allowing centralized management of configuration files.

## Repository Structure

### Gold Scripts (`gold/`)
Collection of standalone Bash utility scripts and installation scripts. These are designed to be:
- Executable shell scripts without file extensions
- Self-contained with dependency validation using `requires` function
- Formatted with `shfmt` and linted with `shellcheck`

**Core Utilities**:
- `is_command` - Check if a command exists
- `is_installed` - Check if a package is installed (via apt)
- `requires` - Validate dependencies before script execution
- `midas` - Package update utility that uses `gum` for styling

**Install Scripts**: Follow pattern `install_<name>` (e.g., `install_docker`, `install_elixir`, `install_ohmyzsh`)

### Configuration Packages
Each directory is a Stow package with configs in their expected subdirectory structure:
- `powershell/` - PowerShell profile with Git/Docker aliases, oh-my-posh integration
- `git/` - Git config with Delta diff viewer and custom aliases
- `neovim/` - Vim-Plug based config with themes, plugins, and CoC integration
- `ohmyposh/` - Custom oh-my-posh theme (`.theme.omp.json`)
- `powerlevel10k/` - Zsh theme configuration (`.p10k.zsh`)
- `elixir/` - IEx configuration (`.iex.exs`)
- `ocaml/` - utop REPL configuration

## Development Commands

### Formatting and Linting
```bash
make format
```
Runs on all Gold scripts:
1. `dos2unix` - Normalizes line endings
2. `shfmt` - Formats with 4-space indent, case-indent, space-redirects
3. `shellcheck` - Lints with all checks enabled

### Package Management with Stow

**Install packages**:
```bash
stow --dir "${HOME}/.dotfiles" --target "${HOME}" --stow <package_names>
```

**Remove packages**:
```bash
stow --dir "${HOME}/.dotfiles" --target "${HOME}" --delete <package_names>
```

**Update packages after pulling changes**:
```bash
cd "${HOME}/.dotfiles"
git pull origin main
stow --dir "${HOME}/.dotfiles" --target "${HOME}" --restow <package_names>
```

**Update Gold utilities** (when installed to `/usr/local/bin`):
```bash
midas update
```

### Quick Install Script
For Linux/Mac environments:
```bash
curl -fsSL https://shell.jasonwohlgemuth.me/install.sh | bash
```
Or with specific packages:
```bash
curl -fsSL https://shell.jasonwohlgemuth.me/install.sh | bash -s -- <package_names>
```

## Shell Script Development

### Required Tools
- `dos2unix` - Line ending normalization
- `shfmt` - Shell script formatter
- `shellcheck` - Shell script linter
- `git` - Version control
- `stow` - Symlink farm manager

### Gold Script Conventions
1. **Shebang**: Use `#! /bin/bash`
2. **Error handling**: Include `set -e` to exit on errors
3. **Dependencies**: Use `requires` function at top of main script
4. **Naming**: Utilities are verb phrases (e.g., `is_command`), installers use `install_` prefix
5. **Shellcheck**: Disable rules sparingly with inline comments (e.g., `# shellcheck disable=SC2312`)
6. **Format**: 4-space indentation, case indentation, space redirects

### Global Shellcheck Configuration
`.shellcheckrc` disables SC2312 (masking pipe return values) globally.

## PowerShell Profile Features

The PowerShell profile (`powershell/.config/powershell/Microsoft.PowerShell_profile.ps1`) includes:
- **Git aliases**: `g`, `gcam`, `gd`, `glo`, `gpom`, `grbi`, `gsb`, `gco`
- **Docker aliases**: `dps`, `dpa`, `dip`, `dra`, `dri`
- **Directory traversal**: `u`, `uu`, `uuu`, `uuuu`, `uuuuu` (equivalent to `../`, `../../`, etc.)
- **Tool integration**: zoxide, McFly, oh-my-posh, glab completion
- **PSReadLine**: Tab completion with MenuComplete, history search with arrow keys
- **Modules**: Automatically imports PSScriptAnalyzer, posh-git, Terminal-Icons, Prelude

## Git Configuration

Uses [Delta](https://github.com/dandavison/delta) as pager with:
- Side-by-side diffs
- Line numbers
- Navigation support
- diff3 merge conflict style

**Custom aliases**:
- `git last` - Show hash of last commit
- `git changed` - Show files changed in a commit

## Contributing

All new shell scripts must:
1. Be functional (tested)
2. Pass `shfmt` formatting
3. Pass `shellcheck` linting (no new issues)

See CONTRIBUTING.md for tool installation guidance (Scoop for Windows, Homebrew for Linux/Mac).
