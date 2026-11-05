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

2. Install vim-plug and the declared plugins explicitly:

```bash
nvim --headless --cmd 'let g:bootstrap_plugins = 1' '+PlugInstall --sync' +qa
```

Ordinary Neovim startup never downloads vim-plug or installs plugins. Until the
setup command runs, the configuration starts without the plugin layer and shows
an informational message.

The plugin manager and all 36 plugins are pinned to tested upstream commits.
The complete tested revision set is:

- manager: vim-plug `7e5aae5e1187842cb0b1d8def986e48d481c4410`
- completion: coc.nvim `5950d87e3bf9adcc6737526cc065b9c054b95f25`,
  codeium.vim `c5c027c31ba8afd38a718c650f363437fbaeb4bc`, plenary.nvim
  `74b06c6c75e4eeb3108ec01852001636d85a932b`, and codecompanion.nvim
  `9cc3c1352181253d6a65c709431f30a90a45eb05`
- navigation: fzf `99bfd5aa0f66133d7dcfbf18f8044eb765f04649`, fzf.vim
  `023de3c0e158ff9c2b0992175af10be97c2f2158`, fzf-preview.vim
  `933836744ad5907653bc903d027eb1a08ed95811`, vim-sneak
  `feea86adcfbf8e6b5e71fdd5f4f5736fd8819fdb`, and vim-choosewin
  `839da609d9b811370216bdd9d4512ec2d0ac8644`
- UI: vim-airline `8dc1bd0a116de527f6bc58c1d04386ba357c624f`,
  vim-airline-themes `77aab8c6cf7179ddb8a05741da7e358a86b2c3ab`, onedark.vim
  `47bec7a6196a843dad195d2666c3ac84c6e80c78`, rainbow
  `76ca1a20aa42edb5c65c19029968aad4625790dc`, vim-which-key
  `72a4267b46a76f541b3e9500a7503575575d4f57`, nvim-colorizer.lua
  `72a05f62c52241bc7441c820eb53946f92b2e6a4`, and csv.vim
  `375c1a81a4f186ce8949824f3b87ddc6727a63af`
- editing: vim-commentary `64a654ef4a20db1727938338310209b6a63f60c9`,
  vim-surround `3d188ed2113431cf8dac77be61b842acb64433d9`, nvim-autopairs
  `3172f40c16563db871a58f20d205c710ad782311`, vim-visual-multi
  `a6975e7c1ee157615bbc80fc25e4392f71c344d4`, vim-closetag
  `d0a562f8bdb107a50595aefe53b1a690460c3822`, tabular
  `12437cd1b53488e24936ec4b091c9324cafee311`, and undotree
  `6fa6b57cda8459e1e4b2ca34df702f55242f4e4d`
- Git: vim-fugitive `3b753cf8c6a4dcde6edee8827d464ba9b8c4a6f0` and
  vim-signify `e7557022f94270e887cbb391a746c1818e570d7f`
- language-specific: vim-jsx-pretty
  `6989f1663cc03d7da72b5ef1c03f87e6ddb70b41`, vim-nix
  `7235c7ce2cea530cb6b59bc3e46d4bfe917d15c8`, vim-polyglot
  `f061eddb7cdcc614c8406847b2bfb53099832a4e`, rust.vim
  `2beee60144703b574fd95adaa07e0dfd83e71006`, and crates.nvim
  `7039bc1d130e424232a7aa64ceddb170a154ff5b`
- tools: orgmode `a7fdbd3cfdd94b425c655cc72e3a6c4dd0a3959f`, ALE
  `422c0e8ef42e2315a5b58dc281fccc59b816c37a`, Snacks
  `882c996cf28183f4d63640de0b4c02ec886d01f2`, markdown-preview.nvim
  `a923f5fc5ba36a3b17e289dc35dc17f66d0548ee`, vim-bookmarks
  `9cc5fa7ecc23b052bd524d07c85356c64b92aeef`, and vim-devicons
  `71f239af28b7214eebb60d4ea5bd040291fb7e33`

To review an update, resolve the candidate commit in the plugin's primary
upstream repository, review its changes, and replace the full commit in both
`plugins.vim` and the Docker `pinned-plugins` check. Then rebuild the complete
image without cached layers:

```bash
docker build --no-cache neovim
```

The build installs every plugin from scratch, asserts each checkout's exact Git
HEAD, loads the full configuration headlessly, exercises the lazy Markdown
plugin and Snacks picker, and loads Orgmode's compiled tree-sitter parser. The
image includes a C toolchain because Orgmode compiles its required
tree-sitter-org grammar during setup.

The container uses the checksum-verified Neovim 0.12.6 release archives so the
test baseline supports CodeCompanion's configured ACP adapter.

3. Start Neovim and optionally run health checks:

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
