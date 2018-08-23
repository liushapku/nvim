
" qf#SetQF(lines[, option_dic])
" option_dic: key:
"   nojump: do not jump, default 0
function! qf#SetQF(data, ...)
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

function! qf#GetQFFromNeoterm(type, ...) abort
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

function! qf#LocateQF()
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
