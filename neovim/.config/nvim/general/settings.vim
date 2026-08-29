set autoindent
set autoread
set background=dark
set cmdheight=1
set cursorline
set encoding=UTF-8
set expandtab
set hidden
set nobackup
set nocompatible
set noswapfile
set nowrap
set nowritebackup
set number
set ruler
set shortmess+=c
set smartindent
set smarttab
set termguicolors
set timeoutlen=100
let s:undo_dir = stdpath('state') . '/undo'
if !isdirectory(s:undo_dir)
    call mkdir(s:undo_dir, 'p')
endif
let &undodir = s:undo_dir
set undofile
set updatetime=100
syntax enable
filetype plugin indent on
set foldmethod=indent
