" Disable ALE's LSP features — coc.nvim handles all LSP
let g:ale_disable_lsp = 1

" Only run linters explicitly configured
let g:ale_linters_explicit = 1

" Non-LSP linters per filetype (covers gaps in coc extensions)
let g:ale_linters = {
\   'sh':         ['shellcheck'],
\   'bash':       ['shellcheck'],
\   'zsh':        ['shellcheck'],
\   'markdown':   ['markdownlint', 'vale'],
\   'dockerfile': ['hadolint'],
\   'gitcommit':  ['gitlint'],
\   'yaml':       ['yamllint'],
\}

" Fixers: universal whitespace + shfmt for shell scripts
let g:ale_fixers = {
\   '*':         ['trim_whitespace', 'remove_trailing_lines'],
\   'sh':        ['shfmt'],
\   'bash':      ['shfmt'],
\   'zsh':       ['shfmt'],
\}

" Match shfmt flags from Makefile
let g:ale_sh_shfmt_options = '-i 4 -ci -sr'

" Fix on save
let g:ale_fix_on_save = 1

" UI
let g:ale_sign_column_always = 1
let g:ale_sign_error = '>>'
let g:ale_sign_warning = '--'
let g:ale_virtualtext_cursor = 'disabled'

" Avoid double-linting while typing (coc handles real-time for LSP langs)
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_enter = 1
let g:ale_lint_on_save = 1

" Navigate ALE diagnostics (distinct from coc's [g / ]g)
nmap <silent> <leader>gj <Plug>(ale_next_wrap)
nmap <silent> <leader>gk <Plug>(ale_previous_wrap)
