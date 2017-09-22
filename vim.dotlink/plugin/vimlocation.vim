
" bang: use pedit, else use new
command! -narg=1 -bang -complete=command EditCommand call vimlocation#edit_command(<q-mods>, <bang>0, <q-args>)
command! -narg=1 -bang -complete=function EditFunction call vimlocation#edit_function(<q-mods>, <bang>0, <q-args>)
command! -narg=+ -bang -complete=mapping EditMap call vimlocation#edit_map(<q-mods>, <bang>0, <f-args>)
