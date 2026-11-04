" Install vim-plug only through the explicit bootstrap command.
let s:plug_vim = stdpath('data') . '/site/autoload/plug.vim'
let s:bootstrap_plugins = get(g:, 'bootstrap_plugins', 0)
if empty(glob(s:plug_vim)) && s:bootstrap_plugins && executable('curl')
    silent execute '!curl -fLo ' . shellescape(s:plug_vim)
        \ . ' --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
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
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'Exafunction/codeium.vim'
Plug 'nvim-lua/plenary.nvim'
Plug 'olimorris/codecompanion.nvim'

" === Navigation ===
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'yuki-ycino/fzf-preview.vim'
Plug 'justinmk/vim-sneak'
Plug 't9md/vim-choosewin'

" === UI / Appearance ===
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'joshdick/onedark.vim'
Plug 'luochen1990/rainbow'
Plug 'liuchengxu/vim-which-key'
Plug 'catgoose/nvim-colorizer.lua', {'as': 'colorizer'}
Plug 'chrisbra/csv.vim'

" === Editing ===
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'windwp/nvim-autopairs'
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
Plug 'alvan/vim-closetag'
Plug 'godlygeek/tabular'
Plug 'mbbill/undotree'

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
