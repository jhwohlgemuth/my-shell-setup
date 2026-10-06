# Neovim Configuration Guide

This package contains the Neovim setup used by this repository.

## Location and Structure

- Main config root: `.config/nvim/`
- Entry point: `.config/nvim/init.vim`
- Global settings and mappings: `.config/nvim/general/`
- Plugin declarations: `.config/nvim/general/plugins.vim`
- Plugin-specific settings: `.config/nvim/plug-config/`

## Setup

1. Stow the package into your home directory:

```bash
stow --dir "${HOME}/.dotfiles" --target "${HOME}" --stow neovim
```

This installs the configuration at `~/.config/nvim` on Linux and macOS.

2. Start Neovim. If plugins are missing, vim-plug will auto-install them on startup.

3. Optional health checks:

```vim
:checkhealth
:checkhealth codecompanion
```

On Windows, run `Invoke-WindowsSetup.ps1` from the repository root. It copies
this package to `%LOCALAPPDATA%\nvim`, the location returned by
`stdpath('config')` in a standard Windows Neovim installation.

## Daily Usage

### Leader Key

- Leader is Space.
- Press Space and pause briefly to open WhichKey hints.

### File Search and Navigation

Primary picker is Snacks.

- Space ff: Find files
- Space fg: Grep text
- Space fb: Buffers
- Space fh: Help tags

Fallback fzf commands are also available:

- `:Files`
- `:Rg <pattern>`
- `:RG <pattern>` for live-reload ripgrep
- `:GGrep <pattern>` for git grep

### CoC (LSP, completion, refactors)

- Ctrl+Space: Trigger completion
- gd / gi / gr / gy: Definition, implementation, references, type definition
- K: Hover docs
- [g / ]g: Previous and next CoC diagnostic
- Space rn: Rename symbol
- Space f: Format selection or buffer region
- Space a: Code action (selection/current context)
- Space ac: Code action (current buffer)
- Space qf: Apply quick fix on current line
- Ctrl+\: Toggle CoC Explorer file tree

Useful CoC commands:

- `:CocList diagnostics`
- `:CocList outline`
- `:CocList symbols`
- `:Format`
- `:OR` (organize imports)

If an existing installation reports `(e.adapter || i.adapter) is not a function`
on startup, check `:CocOpenLog`. The bundled downloader in `coc-reason` 0.1.2
causes this error; this setup no longer installs that extension. Run
`:CocUninstall coc-reason` once to remove an already-installed copy, then restart
Neovim. Removing an extension from the automatic install list alone does not
uninstall it.

On Windows, `Error on install ...: Error: spawn EINVAL` can indicate an old CoC
release trying to launch `npm.cmd` directly with a newer Node.js version. Run
`:PlugUpdate coc.nvim`, restart Neovim, and retry with
`:CocInstall coc-pyright @yaegassy/coc-ruff`. CoC's updated installer handles
Windows command wrappers; changing Python settings does not fix this failure.

### Optional Reason / OCaml Support

CoC configures OCaml-LSP automatically when both `ocamllsp` and `refmt` are on
Neovim's PATH. If either is missing, this setup skips the server configuration.
The server is used for `reason` and `ocaml` buffers.

Install the dependencies in your project's opam switch:

```sh
opam install ocaml-lsp-server reason
opam exec -- nvim
```

Launch Neovim from the project directory with the appropriate switch active.
Restart Neovim after installing dependencies or changing switches. This uses
CoC's language server support directly and does not require `coc-reason`.

### ALE (non-LSP lint/fix)

ALE is used for non-LSP tools while CoC handles LSP.

- Auto-fix on save is enabled
- Shell files use shfmt
- Markdown uses markdownlint and vale
- YAML uses yamllint
- Dockerfiles use hadolint

Diagnostic navigation:

- Space gj: Next ALE issue
- Space gk: Previous ALE issue

### CodeCompanion (configured for local OpenCode)

CodeCompanion is configured to use the OpenCode ACP adapter.

- Config file: `.config/nvim/plug-config/codecompanion.vim`
- Chat adapter: `opencode`

Keymaps:

- Ctrl+Shift+A (normal): Toggle chat
- Ctrl+Shift+A (visual): Add selected text to chat
- Leader cc (normal): Fallback toggle chat
- Leader cc (visual): Fallback add selected text to chat
- Ctrl+Shift+P: Open actions palette
- Ctrl+I: Start inline prompt in current buffer

How to use it effectively:

1. Start your local OpenCode stack so `opencode acp` works.
2. Open chat with Ctrl+Shift+A.
3. For file-aware prompts, visually select code and press Ctrl+Shift+A.
4. Use Ctrl+I when you want in-place edits directly in the buffer.

Troubleshooting:

- Run `:checkhealth codecompanion`
- Confirm `opencode` is on PATH
- Confirm your OpenCode config points to your local provider/model

## Other Less-Obvious Plugins

### Snacks

Enabled modules include dashboard, picker, terminal, lazygit, notifier, zen, and more.

Common useful commands via WhichKey:

- Space z: Zen mode
- Space t ;: Toggle terminal
- Space t g: LazyGit terminal
- Space t e: Floating explorer

### ChooseWin

Quickly jump focus between windows:

- Space w

### Undotree

Visual undo history:

- Space u

### Bookmarks

- Space b a: Toggle bookmark
- Space b i: Annotate bookmark
- Space b s: Show all bookmarks
- Space b c: Clear bookmarks in current buffer

### Markdown Preview

- Space m

### Orgmode

[nvim-orgmode](https://github.com/nvim-orgmode/orgmode) requires Neovim 0.12.0 or later.
Create `~/orgfiles` for your Org files; the agenda searches this directory recursively,
and captured notes go to `~/orgfiles/refile.org`.

- Space o a: Open agenda prompt
- Space o c: Open capture prompt
- `g?` in an Org buffer: Show available mappings
- `:help orgmode.txt`: Open documentation

Settings are in `.config/nvim/plug-config/orgmode.vim`.

### Sneak

Fast two-character motion with labeled targets.

- Use normal Sneak motions and follow labels for rapid jumps.

## Notes

- CoC snippets are enabled and UltiSnips is disabled.
- Plugin-specific configuration is intentionally split into files under `.config/nvim/plug-config/` for easier maintenance.
