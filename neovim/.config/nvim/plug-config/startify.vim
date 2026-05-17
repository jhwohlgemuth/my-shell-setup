let s:startify_ascii_header = [
\ '███╗░░██╗███████╗░█████╗░██╗░░░██╗██╗███╗░░░███╗',
\ '████╗░██║██╔════╝██╔══██╗██║░░░██║██║████╗░████║',
\ '██╔██╗██║█████╗░░██║░░██║╚██╗░██╔╝██║██╔████╔██║',
\ '██║╚████║██╔══╝░░██║░░██║░╚████╔╝░██║██║╚██╔╝██║',
\ '██║░╚███║███████╗╚█████╔╝░░╚██╔╝░░██║██║░╚═╝░██║',
\ '',
\]
let g:startify_custom_header = map(s:startify_ascii_header + startify#fortune#quote(), '"   ".v:val')
let g:webdevicons_enable_startify = 1
function! StartifyEntryFormat()
    return 'WebDevIconsGetFileTypeSymbol(absolute_path) ." ". entry_path'
endfunction
