let g:which_key_timeout = 100
let g:which_key_display_names = {'<CR>': '↵', '<TAB>': '⇆'}
let g:which_key_sep = '→'
let g:which_key_map =  {}
" Hide status line
autocmd! FileType which_key
autocmd  FileType which_key set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 noshowmode ruler
let g:which_key_map['c'] = [':Commentary', 'comment line']
let g:which_key_map['e'] = [':CocCommand explorer --toggle', 'explorer']
let g:which_key_map['i'] = [':lua Snacks.indent.toggle()', 'indent guides']
let g:which_key_map['l'] = [':CocList snippets', 'list snippets']
let g:which_key_map['m'] = [':MarkdownPreview', 'preview']
let g:which_key_map['s'] = ['z=', 'spelling']
let g:which_key_map['u'] = [':UndotreeToggle', 'undo tree']
let g:which_key_map['w'] = [':ChooseWin', 'window']
let g:which_key_map['z'] = [':lua Snacks.zen()', 'zen']
let g:which_key_map.b = {
      \ 'name' : '+bookmark' ,
      \ 'a' : [':BookmarkToggle', 'add bookmark'],
      \ 'i' : [':BookmarkAnnotate', 'annotate bookmark'],
      \ 's' : [':BookmarkShowAll', 'show all'],
      \ 'c' : [':BookmarkClear', 'clear buffer'],
      \ }
let g:which_key_map.t = {
      \ 'name' : '+terminal' ,
      \ ';' : [':lua Snacks.terminal.toggle("default")', 'terminal'],
      \ 'd' : [':lua Snacks.terminal.toggle("lazydocker", "lazydocker")', 'docker'],
      \ 'e' : [':CocCommand explorer --toggle --sources=file+ --preset floating', 'explorer'],
      \ 'f' : [':lua Snacks.terminal.toggle("fsi", "dotnet fsi")', 'F#'],
      \ 'g' : [':lua Snacks.lazygit()', 'git'],
      \ 'm' : [':lua Snacks.terminal.toggle("python", "python")', 'python'],
      \ 'n' : [':lua Snacks.terminal.toggle("node", "node")', 'node'],
      \ 'p' : [':lua Snacks.terminal.toggle("powershell", "powershell")', 'powershell'],
      \ 't' : [':lua Snacks.terminal.toggle()', 'toggle'],
      \ }
call which_key#register('<Space>', "g:which_key_map")
