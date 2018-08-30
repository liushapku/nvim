
" bang: use pedit, else use new
command! -narg=? -bang -complete=command EditCommand call vimlocation#edit_command(<q-mods>, <bang>0, <q-args>)
command! -narg=? -bang -complete=function EditFunction call vimlocation#edit_function(<q-mods>, <bang>0, <q-args>)
" EditMap i <S-Tab>
command! -narg=+ -bang -complete=mapping EditMap call vimlocation#edit_map(<q-mods>, <bang>0, <f-args>)

nnoremap <leader>e :call vimlocation#ExeLines()<CR>
vnoremap <leader>e :call vimlocation#ExeLines()<CR>
command! -register ExeReg :<c-u>call vimlocation#ExeReg(<q-reg>)<cr>

""""""""""""""""""""""
command! -nargs=* RegCopy call vimlocation#CopyRegister(<f-args>)
