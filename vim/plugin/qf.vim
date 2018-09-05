
"errorformat=%C %.%#,%A  File "%f"\, line %l%.%#,%Z%[%^ ]%\@=%m
"set efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m
"let g:python_traceback_format0='%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m'
let g:python_traceback_format0=join([
    \ '%A  File "%f"\, line %l\, %m',
    \ '%A  File "%f"\, line %l',
    \ "%Z%p^",
    \ "%Z    %m",
    \ ], ',')
let g:python_traceback_format2=join([
    \ '%A %#  File "%f"\, line %l\, %m',
    \ '%A %#  File "%f"\, line %l',
    \ "%Z%p^",
    \ "%Z %#    %m",
    \ ], ',')
" for result from ctest
let g:python_traceback_format1=join([
    \ '%A%\d%\+:  %#  File "%f"\, line %l\, %m',
    \ '%A%\d%\+:  %#  File "%f"\, line %l',
    \ '%Z%\d%\+: %p^',
    \ '%Z%\d%\+:  %#    %m',
    \ ], ',')
let g:python_traceback_format_ipython=join([
    \ '%A[FILE]:%f %m',
    \ '%C %\+%\d%\+%.%#',
    \ '%C-%\+> %l %m',
    \ '%A%^%$'
    \ ], ',')

let g:python_traceback_format=join([g:python_traceback_format2, g:python_traceback_format1], ',')

" read qf list from data (string list), optional value is a dict, which may
" contain the following keys:
" 'location': 'quickfix' (default). Any other string uses location list
" 'efm': errorformat, default to the current &efm
" 'nojump': bool, do not jump to first error automatically



" get QF list from neoterm
command! -bang QFFromNeoterm call qf#GetQFFromNeoterm('ipython', {'nojump':<bang>0})

command! -bar QFClear :call setqflist([], 'r')
" reverse the QF list
command! -bar QFReverse :call setqflist(reverse(getqflist()), 'r')
" set QF from a register, if bang, then do not jump to the first one
command! -register -bang -bar QFset :call qf#SetQF(getreg(<q-reg>, 0), {'nojump':<bang>0})
command! -register -bang -bar QFSet :QFset <reg> | QFReverse

vnoremap ;Qf :call qf#SetQF(getline(line("'<"), line("'>")), {'nojump':1})<cr>
nnoremap ;Qf :call qf#SetQF(qf#LocateQF(), {'nojump':1})<cr>
nnoremap ;qf :<c-u>QFset *<cr>
nnoremap ;qF :<c-u>QFSet *<cr>


command! -nargs=1 QFn  call qf#Search(<q-args>, 0, "")
command! -nargs=1 QFnf call qf#Search(<q-args>, 0, "file")
command! -nargs=1 QFnt call qf#Search(<q-args>, 0, "text")
command! -nargs=1 QFp  call qf#Search(<q-args>, 1, "")
command! -nargs=1 QFpf call qf#Search(<q-args>, 1, "file")
command! -nargs=1 QFpt call qf#Search(<q-args>, 1, "text")
