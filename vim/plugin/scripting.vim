
let g:IFS = ''

" bang: use pedit, else use edit
command! -narg=? -bang -complete=command EditCommand call scripting#edit_command(<q-mods>, <bang>0, <q-args>)
command! -narg=? -bang -complete=function EditFunction call scripting#edit_function(<q-mods>, <bang>0, <q-args>)
" e.g. EditMap i <S-Tab>
command! -narg=+ -bang -complete=mapping EditMap call scripting#edit_map(<q-mods>, <bang>0, <f-args>)

command! Doft doautocmd FileType
nnoremap ;e <Cmd>Doft<cr>
nnoremap <silent> <leader>E :call scripting#ExeLines()<CR>
vnoremap <silent> <leader>E :call scripting#ExeLines()<CR>
command! -register ExeReg :call scripting#ExeReg(<q-reg>)

""""""""""""""""""""""
command! -nargs=* RegCopy call scripting#CopyRegister(<f-args>)
command! -nargs=* CopyReg call scripting#CopyRegister(<f-args>)

command! -narg=+ -range=-999999 PutOutput call append(<line1>, split(execute(<q-args>), "\n"))

command! -nargs=1 Parse echo scripting#parse({'[KMAP]':{'v':'verbose'}}, <q-args>)
"Parse --a=3 --b<=$SHELL --c=$HOME git -m'a b c'
"[{'a': '3', 'b': 'zsh', 'c': '$HOME', 'm': 'a b c'}, ['git']]
"

command! -nargs=1 IFS call scripting#with_ifs(<q-args>)
"IFS is one character
"IFS, Parse  --a=3, --b<=$SHELL , --c=$HOME,git,-ma b c
"[{'a': '3', 'b': 'zsh', 'c': '$HOME', 'm': 'a b c'}, ['git']]
