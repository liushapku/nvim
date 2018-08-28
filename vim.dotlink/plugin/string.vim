command! -register -nargs=? StripReg call setreg(<q-args> == ''? <q-reg>:<q-args>, string#TrimNewlines(getreg(<q-reg>)), 'v')
" put character wise, with a <bang> work using P, otherwise p
command! -register -bang -nargs=* Put call string#PutCharacterwise(<bang>0, <q-reg>, <q-args>)

" force characterwise put
nmap cp :<c-u>exe "Put " . v:register<cr>
nmap cP :<c-u>exe "Put! " . v:register<cr>
vmap cp <esc>`>cpgvd
vmap cP cp
" force linewise put
"nnoremap <space>p :<c-u>exe (v:count == 0? "": v:count) . "put" v:register<cr>
"nnoremap <space>P :<c-u>exe (v:count == 0? "": v:count) . "-put" v:register<cr>

" put to end or beginning of line, keep one space using J
"nnoremap <expr> <leader>p (getline('.') =~ '\s$'? '$' : 'A <esc>') . '"' . v:register . v:count1 . 'p'
"nnoremap <expr> <leader>P '^"' . v:register . v:count1 . (getreg(v:register) =~ '\s$'? '': 'Pa <esc>')
nnoremap <leader>p :<c-u>exe (v:count == 0? "": v:count) . "put" v:register<cr>kJ
nnoremap <leader>P :<c-u>exe (v:count == 0? "": v:count) . "-put" v:register<cr>J
" put to end or beginning of line, do not change space (using gJ)
nnoremap <leader>gp :<c-u>exe (v:count == 0? "": v:count) . "put" v:register<cr>kgJ
nnoremap <leader>gP :<c-u>exe (v:count == 0? "": v:count) . "-put" v:register<cr>gJ


command! -range -bang -narg=+ CopyLine call string#CopyLine(<line2>, <bang>0, <f-args>)
command! -bang -narg=+ MoveLine call string#MoveLine(<bang>0, <f-args>)


"111111 11111 1111111
"b
"2222222222 2222222 222222
"
"
"
