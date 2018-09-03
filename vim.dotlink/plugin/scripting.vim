
" bang: use pedit, else use new
command! -narg=? -bang -complete=command EditCommand call scripting#edit_command(<q-mods>, <bang>0, <q-args>)
command! -narg=? -bang -complete=function EditFunction call scripting#edit_function(<q-mods>, <bang>0, <q-args>)
" e.g. EditMap i <S-Tab>
command! -narg=+ -bang -complete=mapping EditMap call scripting#edit_map(<q-mods>, <bang>0, <f-args>)

nnoremap <leader>e :call scripting#ExeLines()<CR>
vnoremap <leader>e :call scripting#ExeLines()<CR>
command! -register ExeReg :<c-u>call scripting#ExeReg(<q-reg>)<cr>

""""""""""""""""""""""
command! -nargs=* RegCopy call scripting#CopyRegister(<f-args>)

command! -narg=+ -range=-999999 PutOutput call append(<line1>, split(execute(<q-args>), "\n"))

