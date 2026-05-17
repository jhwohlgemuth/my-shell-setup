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
Plug 'mhinz/vim-startify'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'luochen1990/rainbow'
Plug 'liuchengxu/vim-which-key'
Plug 'junegunn/goyo.vim'
Plug 'norcalli/nvim-colorizer.lua'
Plug 'psliwka/vim-smoothie'
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
Plug 'davidhalter/jedi-vim'

" === Tools ===
Plug 'dense-analysis/ale'
Plug 'voldikss/vim-floaterm'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
Plug 'MattesGroeger/vim-bookmarks'

call plug#end()

" Source plugin-specific configs
source $VIMCONFIG/plug-config/airline.vim
source $VIMCONFIG/plug-config/choosewin.vim
source $VIMCONFIG/plug-config/colorizer.vim
source $VIMCONFIG/plug-config/floaterm.vim
source $VIMCONFIG/plug-config/indent-guides.vim
source $VIMCONFIG/plug-config/rainbow.vim
source $VIMCONFIG/plug-config/sneak.vim
source $VIMCONFIG/plug-config/startify.vim
