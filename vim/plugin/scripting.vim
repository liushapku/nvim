
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

command! -nargs=1 Parse call scripting#parse({'_KMAP':{'v':'verbose'}}, <q-args>)
"Parse --a=3 --b:=$HOME --c=$HOME git -m'a b c'
"parsed args {'b': '$HOME', 'c': '/home/liusha'} ['git', '-ma b c']
