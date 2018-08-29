
call operator#user#define('DictReplace', 'dict#Replace')
call operator#user#define('DictGet', 'dict#Get')
call operator#user#define('DictGET', 'dict#GET')
map dc <Plug>(operator-DictReplace)
" get as key = val
map dg <Plug>(operator-DictGet)
" get as val = key
map dg; <Plug>(operator-DictGET)


" function! dict#GetLines(line1, line2, reg, force, reverse) abort
" get as key = val
" with !, existing items are overwritten
command! -register -bang -range Dictget call dict#GetLines(<line1>, <line2>, <q-reg>, <bang>0, 0)
" get as val = key
" with !, existing items are overwritten
command! -register -bang -range DictGet call dict#GetLines(<line1>, <line2>, <q-reg>, <bang>0, 1)


