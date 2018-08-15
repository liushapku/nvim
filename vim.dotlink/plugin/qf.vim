
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

function! WriteVariable(data, file)
    call writefile(split(a:data, "\n", 1), a:file)
endfunction

" read qf list from data (string list), optional value is a dict, which may
" contain the following keys:
" 'location': 'quickfix' (default). Any other string uses location list
" 'efm': errorformat, default to the current &efm
" 'nojump': bool, do not jump to first error automatically
function! SetQF(data, ...)
  if a:data is ''
    call setqflist([])
    cclose
    return
  endif
  let opts = a:0 == 0? {} : a:1
  let nojump = get(opts, 'nojump', 0)
  let tempfile = Tempname()
  let data = type(a:data) == v:t_string?  split(a:data, "\n") : a:data
  let strs = filter(data, 'v:val != ""')
  call writefile(strs, tempfile)
  let position = get(opts, 'location', 'quickfix')
  let cmd = position == 'quickfix' ? 'cg ' : 'lg '
  let oldefm = &efm
  let &efm = get(opts, 'efm', &efm)
  exec cmd . tempfile
  let &efm = oldefm
  bo cw
  if nojump
    wincmd p
  else
    normal "\<cr>"
  endif
endfunction

function! LocateQF()
  let l1 = search('Traceback', 'b')
  if l1 == 0
    echoerr 'LocateQF: cannot find traceback'
    return ''
  endif
  let l2 = search('^\(\d\+: \)\?\S\+Error', 'W')
  if l2 == 0
    echoerr 'LocateQF: cannot find traceback'
    return ''
  endif
  return getline(l1+1, l2)
endfunction

function! GetQFFromNeoterm(type, ...) abort
  let bufid = g:neoterm.repl.instance().buffer_id
  let switch=buffer#SwitchToBuffer(bufid)
  let temp = @"
  normal G
  silent normal :?Traceback?+1;/^\(\d\+: \)\?\s*\S\+Error/y "
  call buffer#SwitchBack(switch)
  if a:type == 'ipython'
      let msg = substitute(@", "\n\n", "\n\n[FILE]:", "g")
      let msg = "[FILE]:" . msg
      let efm = g:python_traceback_format_ipython
  elseif a:type == 'python'
      let msg = string#SearchAndSubstitute(@", '\(\d\+: \)\?  File .*, line \d\+, in \w\+', "$", '():', '')
      let efm = g:python_traceback_format
  else
      let msg = @"
      let efm = &efm
  endif
  call SetQF(msg, {'efm': efm})
  let @"=temp
  bo cw
  let opts = get(a:000, 0, {})
  let nojump = get(opts, 'nojump', 0)
  echo nojump
  if nojump
    wincmd p
  else
    normal "\<cr>"
  endif
endfunction

vnoremap ;qf :call SetQF(getline(line("'<"), line("'>")), {'nojump':1})<cr>
nnoremap ;qf :call SetQF(LocateQF(), {'nojump':1})<cr>
command! QFClear :call setqflist([]) | cw
" get QF list from neoterm
command! -bang QFFromNeoterm call GetQFFromNeoterm('ipython', {'nojump':<bang>0})
" reverse the QF list
command! QFReverse call setqflist(reverse(getqflist()))
" set QF from a register, if bang, then do not jump to the first one
command! -register -bang QFSet call SetQF(@<reg>, {'nojump':<bang>0})
