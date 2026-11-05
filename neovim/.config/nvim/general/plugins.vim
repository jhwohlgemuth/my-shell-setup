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
Plug 'vim-airline/vim-airline', {'commit': '8dc1bd0a116de527f6bc58c1d04386ba357c624f'}
Plug 'vim-airline/vim-airline-themes', {'commit': '77aab8c6cf7179ddb8a05741da7e358a86b2c3ab'}
Plug 'joshdick/onedark.vim', {'commit': '47bec7a6196a843dad195d2666c3ac84c6e80c78'}
Plug 'luochen1990/rainbow', {'commit': '76ca1a20aa42edb5c65c19029968aad4625790dc'}
Plug 'liuchengxu/vim-which-key', {'commit': '72a4267b46a76f541b3e9500a7503575575d4f57'}
Plug 'catgoose/nvim-colorizer.lua', {'as': 'colorizer', 'commit': '72a05f62c52241bc7441c820eb53946f92b2e6a4'}
Plug 'chrisbra/csv.vim', {'commit': '375c1a81a4f186ce8949824f3b87ddc6727a63af'}

" === Editing ===
Plug 'tpope/vim-commentary', {'commit': '64a654ef4a20db1727938338310209b6a63f60c9'}
Plug 'tpope/vim-surround', {'commit': '3d188ed2113431cf8dac77be61b842acb64433d9'}
Plug 'windwp/nvim-autopairs', {'commit': '3172f40c16563db871a58f20d205c710ad782311'}
Plug 'mg979/vim-visual-multi', {'commit': 'a6975e7c1ee157615bbc80fc25e4392f71c344d4'}
Plug 'alvan/vim-closetag', {'commit': 'd0a562f8bdb107a50595aefe53b1a690460c3822'}
Plug 'godlygeek/tabular', {'commit': '12437cd1b53488e24936ec4b091c9324cafee311'}
Plug 'mbbill/undotree', {'commit': '6fa6b57cda8459e1e4b2ca34df702f55242f4e4d'}

" === Git ===
Plug 'tpope/vim-fugitive', {'commit': '3b753cf8c6a4dcde6edee8827d464ba9b8c4a6f0'}
Plug 'mhinz/vim-signify', {'commit': 'e7557022f94270e887cbb391a746c1818e570d7f'}

" === Language-Specific ===
Plug 'maxmellon/vim-jsx-pretty', {'commit': '6989f1663cc03d7da72b5ef1c03f87e6ddb70b41'}
Plug 'LnL7/vim-nix', {'commit': '7235c7ce2cea530cb6b59bc3e46d4bfe917d15c8'}
Plug 'sheerun/vim-polyglot', {'commit': 'f061eddb7cdcc614c8406847b2bfb53099832a4e'}
Plug 'rust-lang/rust.vim', {'commit': '2beee60144703b574fd95adaa07e0dfd83e71006'}
Plug 'saecki/crates.nvim', {'commit': '7039bc1d130e424232a7aa64ceddb170a154ff5b'}

" === Tools ===
Plug 'nvim-orgmode/orgmode', {'commit': 'a7fdbd3cfdd94b425c655cc72e3a6c4dd0a3959f'}
Plug 'dense-analysis/ale', {'commit': '422c0e8ef42e2315a5b58dc281fccc59b816c37a'}
Plug 'folke/snacks.nvim', {'commit': '882c996cf28183f4d63640de0b4c02ec886d01f2'}
Plug 'iamcco/markdown-preview.nvim', { 'commit': 'a923f5fc5ba36a3b17e289dc35dc17f66d0548ee', 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
Plug 'MattesGroeger/vim-bookmarks', {'commit': '9cc5fa7ecc23b052bd524d07c85356c64b92aeef'}
" vim-devicons must load after the plugins it decorates.
Plug 'ryanoasis/vim-devicons', {'commit': '71f239af28b7214eebb60d4ea5bd040291fb7e33'}

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
