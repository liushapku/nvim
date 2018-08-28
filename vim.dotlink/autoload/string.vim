" equivalent to g/search/s/subpat/sub/opt
function! string#SearchAndSubstitute(str, searchpattern, subpattern, sub, opt)
  let result = []
  for x in split(a:str, "\n")
    if a:searchpattern == '' || match(x, a:searchpattern) != -1
      let x = substitute(x, a:subpattern, a:sub, a:opt)
    endif
    call add(result, x)
  endfor
  return join(result, "\n")
endfunction

" strip white space and newline
function! string#Strip(input_string, ...) abort
  let pt = a:0 == 0? '\s*' : a:1
  let s = substitute(a:input_string, '^' . pt, '', '')
  let s = substitute(s, pt . '$', '', '')
  return s
endfunction


function! string#TrimNewlines(input)
  return string#Strip(a:input, '\(\n\|\s\)*')
endfunction

function! string#CopyLine(toline, noident, line1, line2, ...)
  let ei = &eventignore
  set ei=WinEnter,WinLeave,BufEnter,BufLeave
  let winfrom = a:0 < 1? winnr() : window#Winnr(a:1)
  let winto = a:0 < 2? winnr() : window#Winnr(a:2)
  try
    call buffer#WinExec(winfrom, printf('%d,%dy', a:line1, a:line2))
    call buffer#WinExec(winto, 'exe ' . a:toline . '; normal! ' . (a:noident ? 'p' : ']p'))
  finally
    let &eventignore = ei
  endtry
endfunction
function! string#MoveLine(noident, line1, line2, ...)
  let ei = &eventignore
  set ei=WinEnter,WinLeave,BufEnter,BufLeave
  let winfrom = a:0 < 1? winnr() : window#Winnr(a:1)
  let winto = a:0 < 2? winnr() : window#Winnr(a:2)
  try
    call buffer#WinExec(winfrom, printf('%d,%dyank', a:line1, a:line2))
    call buffer#WinExec(winto, 'exe ' . a:toline . '; normal! ' . (a:noident ? 'p' : ']p'))
  finally
    let &eventignore = ei
  endtry
endfunction

command -register -nargs=* TestReg echo "|" . <q-reg> . "|" . <q-args>
" :TestReg abcd   > |a|bcd
" :TestReg =abc   > ||=abc
" :TestReg [abc   > ||[abc

function! string#PutCharacterwise(putbefore, reg, others)
  let savereg = SaveRegister('=')
  try
    if a:others == ''
      let content = getreg(a:reg)
      let temp = string#TrimNewlines(content)
    elseif a:others[0] != '='
      let temp = a:reg . a:others  " when the arg is abcde, a is treated as reg and the rest is in a:1
    else
      let temp = eval(a:others[1:])
    endif
    if a:putbefore
      normal "=tempP
    else
      normal "=tempp
    endif
  finally
    call RestoreRegister(savereg)
  endtry
endfunction

