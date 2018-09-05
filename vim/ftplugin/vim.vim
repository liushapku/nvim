
for d in split(&runtimepath, ',')
    exec 'setlocal tags+=' . d . '/doc/tags'
endfor



command! -buf -bang -nargs=? TogglePlug call buffer#TogglePlug(<q-args>, <bang>0)
command! -buf -bang -nargs=? EditPlug <mods> vsplit | call buffer#TogglePlug(<q-args>, <bang>0)
nmap <buffer> ;# :<c-u>TogglePlug<cr>
nmap <buffer> ;d :<c-u>EditFunction<cr>
nmap <buffer> ;D :<c-u>EditCommand<cr>
vmap <buffer> ;d y:<c-u>EditFunction <c-r>*<cr>
vmap <buffer> ;D y:<c-u>EditCommand <c-r>*<cr>

setlocal iskeyword+=:
nnoremap <buffer> ;E :<c-u>so %<cr>
inoremap <buffer> ;E <esc>:w<cr>:so %<cr>

setlocal expandtab tabstop=2 softtabstop=2 shiftwidth=2