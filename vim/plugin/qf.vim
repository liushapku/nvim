
"errorformat=%C %.%#,%A  File "%f"\, line %l%.%#,%Z%[%^ ]%\@=%m
"set efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m
"let g:efm_python0='%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m'
"
"%# stands for regex *
let g:efm_python0=join([
      \ '%A  File "%f"\, line %l\, %m',
      \ '%A  File "%f"\, line %l',
      \ "%Z%p^",
      \ "%+Z %#    %.%#",
      \ ], ',')
" for result from ctest
let g:efm_python_ctest=join([
      \ '%A%\d%\+:  %#  File "%f"\, line %l\, %m',
      \ '%A%\d%\+:  %#  File "%f"\, line %l',
      \ '%Z%\d%\+: %p^',
      \ '%+Z%\d%\+:  %#    %.%#',
      \ ], ',')

let g:efm_python1=join([
      \ '%A %#  File "%f"\, line %l\, %m',
      \ '%A %#  File "%f"\, line %l',
      \ "%Z%p^",
      \ "%+Z %#    %.%#",
      \ ], ',')

let g:efm_python_pptest=join([
      \ 'Exception: File "%f"\, line %l\, %m',
      \ 'File "%f"\, line %l\, %m',
      \ ], ',')

let g:efm_python_ipython=join([
      \ '%A[FILE]:%f %m',
      \ '%C %\+%\d%\+%.%#',
      \ '%C-%\+> %l %m',
      \ '%A%^%$'
      \ ], ',')

let g:efm_python=join([
      \ g:efm_python1,
      \ g:efm_python_ctest,
      \ ], ',')
let &efm = g:efm_python_pptest
let &efm = g:efm_python

" read qf list from data (string list), optional value is a dict, which may
" contain the following keys:
" 'location': 'quickfix' (default). Any other string uses location list
" 'efm': errorformat, default to the current &efm
" 'nojump': bool, do not jump to first error automatically



" get QF list from neoterm
command! -bang QFFromNeoterm call qf#GetQFFromNeoterm('ipython', {'nojump':<bang>0})

command! -bar Qclear :call setqflist([], 'r') | cclose
" reverse the QF list
" set QF from a register, if bang, then do not jump to the first one
command! -bang -bar -nargs=* Qf :call qf#SetQF(scripting#parse({'reverse':<bang>0}, <q-args>))

vnoremap ;qf :call qf#SetQF({'data':getline(line("'<"), line("'>")), 'jump':1})<cr>
nnoremap ;qf <Cmd>Qf --reg$=v:register<cr>
nnoremap ;QF <Cmd>Qf! --reg$=v:register<cr>


command! -nargs=1 QFn  call qf#Search(<q-args>, 0, "")
command! -nargs=1 QFnf call qf#Search(<q-args>, 0, "file")
command! -nargs=1 QFnt call qf#Search(<q-args>, 0, "text")
command! -nargs=1 QFp  call qf#Search(<q-args>, 1, "")
command! -nargs=1 QFpf call qf#Search(<q-args>, 1, "file")
command! -nargs=1 QFpt call qf#Search(<q-args>, 1, "text")

" option: set g:Ptest_name_prefix
command! -range=0 -addr=windows -nargs=* Ptest :call qf#Ptest(<q-args>, <line1>, '')

command! -nargs=1 Qfilter call qf#select(scripting#parse(0, <q-args>))
