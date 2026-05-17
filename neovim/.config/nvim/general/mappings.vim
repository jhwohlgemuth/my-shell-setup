let g:mapleader = "\<Space>"

" Save
nnoremap <silent> <C-s> :w<CR>

" Exit terminal mode
tnoremap <Esc> <C-\><C-n>

" Toggle CoC explorer
nnoremap <silent> <C-Bslash> :CocCommand explorer --toggle<CR>

" WhichKey trigger
nnoremap <silent> <leader> :silent <c-u> :silent WhichKey '<Space>'<CR>
vnoremap <silent> <leader> :silent <c-u> :silent WhichKeyVisual '<Space>'<CR>

" Move lines
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==

" FZF
nnoremap <leader>ff :Files<CR>
nnoremap <leader>fg :Rg<CR>
nnoremap <leader>fb :Buffers<CR>
nnoremap <leader>fh :Helptags<CR>
