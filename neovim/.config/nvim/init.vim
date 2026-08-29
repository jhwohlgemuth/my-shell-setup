let $VIMCONFIG = stdpath('config')

execute 'source' fnameescape($VIMCONFIG . '/general/settings.vim')
execute 'source' fnameescape($VIMCONFIG . '/general/mappings.vim')
execute 'source' fnameescape($VIMCONFIG . '/general/plugins.vim')
execute 'source' fnameescape($VIMCONFIG . '/themes/onedark.vim')
