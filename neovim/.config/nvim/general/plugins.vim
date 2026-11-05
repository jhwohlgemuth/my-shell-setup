" Install vim-plug only through the explicit bootstrap command.
let s:plug_vim = stdpath('data') . '/site/autoload/plug.vim'
let s:plug_vim_commit = '7e5aae5e1187842cb0b1d8def986e48d481c4410'
let s:bootstrap_plugins = get(g:, 'bootstrap_plugins', 0)
if empty(glob(s:plug_vim)) && s:bootstrap_plugins && executable('curl')
    silent execute '!curl -fLo ' . shellescape(s:plug_vim)
        \ . ' --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/' . s:plug_vim_commit . '/plug.vim'
endif

if empty(glob(s:plug_vim))
    echohl WarningMsg
    echomsg 'vim-plug is not installed; run the explicit plugin setup command from neovim/README.md'
    echohl None
    finish
endif

if !exists('*plug#begin')
    execute 'source' fnameescape(s:plug_vim)
endif

call plug#begin()

" === LSP / Completion ===
Plug 'neoclide/coc.nvim', {'commit': '5950d87e3bf9adcc6737526cc065b9c054b95f25'}
Plug 'Exafunction/codeium.vim', {'commit': 'c5c027c31ba8afd38a718c650f363437fbaeb4bc'}
Plug 'nvim-lua/plenary.nvim', {'commit': '74b06c6c75e4eeb3108ec01852001636d85a932b'}
Plug 'olimorris/codecompanion.nvim', {'commit': '9cc3c1352181253d6a65c709431f30a90a45eb05'}

" === Navigation ===
Plug 'junegunn/fzf', { 'commit': '99bfd5aa0f66133d7dcfbf18f8044eb765f04649', 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim', {'commit': '023de3c0e158ff9c2b0992175af10be97c2f2158'}
Plug 'yuki-ycino/fzf-preview.vim', {'commit': '933836744ad5907653bc903d027eb1a08ed95811'}
Plug 'justinmk/vim-sneak', {'commit': 'feea86adcfbf8e6b5e71fdd5f4f5736fd8819fdb'}
Plug 't9md/vim-choosewin', {'commit': '839da609d9b811370216bdd9d4512ec2d0ac8644'}

" === UI / Appearance ===
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'joshdick/onedark.vim'
Plug 'luochen1990/rainbow'
Plug 'liuchengxu/vim-which-key'
Plug 'catgoose/nvim-colorizer.lua', {'as': 'colorizer'}
Plug 'chrisbra/csv.vim'

" === Editing ===
Plug 'tpope/vim-commentary', {'commit': '64a654ef4a20db1727938338310209b6a63f60c9'}
Plug 'tpope/vim-surround', {'commit': '3d188ed2113431cf8dac77be61b842acb64433d9'}
Plug 'windwp/nvim-autopairs', {'commit': '3172f40c16563db871a58f20d205c710ad782311'}
Plug 'mg979/vim-visual-multi', {'commit': 'a6975e7c1ee157615bbc80fc25e4392f71c344d4'}
Plug 'alvan/vim-closetag', {'commit': 'd0a562f8bdb107a50595aefe53b1a690460c3822'}
Plug 'godlygeek/tabular', {'commit': '12437cd1b53488e24936ec4b091c9324cafee311'}
Plug 'mbbill/undotree', {'commit': '6fa6b57cda8459e1e4b2ca34df702f55242f4e4d'}

" === Git ===
Plug 'tpope/vim-fugitive'
Plug 'mhinz/vim-signify'

" === Language-Specific ===
Plug 'maxmellon/vim-jsx-pretty'
Plug 'LnL7/vim-nix'
Plug 'sheerun/vim-polyglot'
Plug 'rust-lang/rust.vim'
Plug 'saecki/crates.nvim'

" === Tools ===
Plug 'nvim-orgmode/orgmode'
Plug 'dense-analysis/ale'
Plug 'folke/snacks.nvim'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
Plug 'MattesGroeger/vim-bookmarks'
" vim-devicons must load after the plugins it decorates.
Plug 'ryanoasis/vim-devicons'

call plug#end()

" Source plugin-specific configs
execute 'source' fnameescape($VIMCONFIG . '/plug-config/airline.vim')
execute 'source' fnameescape($VIMCONFIG . '/plug-config/autopairs.vim')
execute 'source' fnameescape($VIMCONFIG . '/plug-config/choosewin.vim')
execute 'source' fnameescape($VIMCONFIG . '/plug-config/colorizer.vim')
execute 'source' fnameescape($VIMCONFIG . '/plug-config/fzf.vim')
execute 'source' fnameescape($VIMCONFIG . '/plug-config/rainbow.vim')
execute 'source' fnameescape($VIMCONFIG . '/plug-config/sneak.vim')
execute 'source' fnameescape($VIMCONFIG . '/plug-config/which-key.vim')
execute 'source' fnameescape($VIMCONFIG . '/plug-config/coc.vim')
execute 'source' fnameescape($VIMCONFIG . '/plug-config/crates.vim')
execute 'source' fnameescape($VIMCONFIG . '/plug-config/orgmode.vim')
execute 'source' fnameescape($VIMCONFIG . '/plug-config/ale.vim')
execute 'source' fnameescape($VIMCONFIG . '/plug-config/snacks.vim')
execute 'source' fnameescape($VIMCONFIG . '/plug-config/codecompanion.vim')
