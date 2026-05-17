" Install vim-plug if not found
let uname = substitute(system('uname'),'\n','','')
if uname == 'Linux'
    if empty(glob('~/.config/nvim/autoload/plug.vim'))
        silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    endif
else
    if empty(glob('~/AppData/Local/nvim/autoload/plug.vim'))
        execute 'silent !curl -fLo' shellescape("%HOMEDRIVE%%HOMEPATH%/AppData/Local/nvim/autoload/plug.vim", 1) '--create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    endif
endif

" Automatically install missing plugins on startup
autocmd VimEnter *
  \  if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \|   PlugInstall --sync | q
  \| endif

call plug#begin()

" === LSP / Completion ===
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'Exafunction/codeium.vim'

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
Plug 'cj/vim-webdevicons'
Plug 'luochen1990/rainbow'
Plug 'liuchengxu/vim-which-key'
Plug 'norcalli/nvim-colorizer.lua'
Plug 'chrisbra/csv.vim'

" === Editing ===
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'jiangmiao/auto-pairs'
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
Plug 'dense-analysis/ale'
Plug 'folke/snacks.nvim'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
Plug 'MattesGroeger/vim-bookmarks'

call plug#end()

" Source plugin-specific configs
source $VIMCONFIG/plug-config/airline.vim
source $VIMCONFIG/plug-config/choosewin.vim
source $VIMCONFIG/plug-config/colorizer.vim
source $VIMCONFIG/plug-config/rainbow.vim
source $VIMCONFIG/plug-config/sneak.vim
source $VIMCONFIG/plug-config/coc.vim
source $VIMCONFIG/plug-config/crates.vim
source $VIMCONFIG/plug-config/ale.vim
source $VIMCONFIG/plug-config/snacks.vim
