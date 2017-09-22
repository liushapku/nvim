
call operator#user#define('DictReplace', 'dict#Replace')
call operator#user#define('DictGet', 'dict#Get')
call operator#user#define('DictGET', 'dict#GET')
call operator#user#define('DictReverse', 'dict#Reverse')
map dc <Plug>(operator-DictReplace)
map dg <Plug>(operator-DictGet)
map dG <Plug>(operator-DictGET)
map dr <Plug>(operator-DictReverse)


" function! dict#GetLines(line1, line2, reg, force, reverse) abort
command! -register -bang -range Dictget call dict#GetLines(<line1>, <line2>, <q-reg>, <bang>0, 0)
command! -register -bang -range DictGet call dict#GetLines(<line1>, <line2>, <q-reg>, <bang>0, 1)


