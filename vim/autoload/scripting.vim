function! scripting#command(command) abort
  let acommand = a:command == ''? expand("<cword>") : a:command
  let output = execute('verb comm ' . acommand)
  let ret = split(output, "\n")
  for x in range(1, len(ret) - 1)
    if ret[x] =~ '\<' . acommand . '\>\s\+'
      return substitute(ret[x+1], '\s*Last set from ', '', '')
    endif
  endfor
endfunction
function! scripting#edit_command(mods, pedit, command) abort
  try
    let file = scripting#command(a:command)
  catch
    echoerr v:exception
  endtry
  if a:pedit
    exe a:mods 'pedit' file
    wincmd P
  elseif !empty(a:mods)
    exe a:mods 'new' file
  else
    exe 'edit' file
  endif
  call search('com.*\<\zs'. a:command . '\>')
  if a:pedit
    normal zt
  else
    normal zz
  endif
endfunction

" echoerr inside try block (including the catch finally) will raise an exception
" when a function contains echoerr, whether the code after echoerr will be
" executed or not depends on whether the caller puts the function inside a try
" block. This may cause inconsistence. So it is better to exit the function
" whenever there is a need to call echoerr.

function! scripting#map(type, command, index) abort
  let acommand = a:command == ''? expand("<cword>") : a:command
  let output = execute('verb ' . a:type . 'map ' . acommand)
  let ret = split(output, "\n")
  if len(ret) == 2
    return substitute(ret[1], '\s*Last set from ', '', '')
  elseif a:index > 0
    return substitute(ret[2*a:index -1], '\s*Last set from ', '', '')
  else
    echo "\n"
    for i in range(len(ret))
      if (i%2 == 0)
        echo (i/2+1) ret[i] ret[i+1]
      endif
    endfor
    let N = len(ret)/2
    let prompt = printf("select [1-%d] >> ", N)
    let n = 0
    while (n > N || n < 1)
      let n = str2nr(input(prompt))
    endwhile
    return substitute(ret[2*n -1], '\s*Last set from ', '', '')
  endif
endfunction
function! scripting#edit_map(mods, pedit, type, command, ...) abort
  let acommand = a:command
  let index = a:0 == 0? 0 : a:1
  try
    let file = call('scripting#map', [a:type, acommand, index])
  catch
    echoerr v:exception
  endtry
  let command = acommand[0] == ';'? ('\(<leader>\|;\)' . acommand[1:]) : acommand
  if a:pedit
    exe a:mods 'pedit' file
    wincmd P
  elseif !empty(a:mods)
    exe a:mods 'new' file
  else
    exe 'edit' file
  endif
  let pattern = '\c.*map .*\zs' . command . ' '
  call search(pattern,  '')
  if a:pedit
    normal zt
  else
    normal zz
  endif
endfunction

function! scripting#function(functionname) abort
  let output = execute('verb function ' . a:functionname)
  let ret = split(output, "\n")
  return substitute(ret[1], '\s*Last set from ', '', '')
endfunction
function! scripting#edit_function(mods, pedit, function) abort
  let afunction = a:function == ''? expand("<cword>") : a:function
  try
    if afunction =~# '^s:'
      " the same file
    else
      let file = scripting#function(afunction)
      if a:pedit
        exe a:mods 'pedit' file
        wincmd P
      elseif !empty(a:mods)
        exe a:mods 'new' file
      else
        exe 'edit' file
      endif
    endif
  catch
    echoerr v:exception
  endtry
  call search('function!\?\s\+\<\zs'. afunction . '\>')
  if a:pedit
    normal zt
  else
    normal zz
  endif
endfunction

function! scripting#ExeLines() range
  let tmp = scripting#SaveRegister("#")
  let file = tempname()
  try
    exe ("silent " . a:firstline . "," . a:lastline . "write " . file)
    exe 'so'  file
  finally
    call scripting#RestoreRegister(tmp)
    call delete(file)
  endtry
endfunction

function! scripting#ExeReg(reg)
  exec substitute(eval("@".a:reg), "\n", "|", "")
endfunction

function! scripting#SaveRegister(reg)
  " if a:reg == "=", the second parameter 1 will make the function return the
  " express instead of the number
  return [a:reg, getreg(a:reg, 1), getregtype(a:reg)]
endfunction
function! scripting#RestoreRegister(values)
  call setreg(a:values[0], a:values[1], a:values[2])
endfunction

function! scripting#CopyRegister(regfrom, regto)
  call setreg(a:regto, getreg(a:regfrom, 1), getregtype(a:regfrom))
endfunction

function! scripting#SaveMark(mk)
  let themark = "'" . a:mk
  let saved = getpos(themark)
  return [themark, saved]
endfunction
function! scripting#RestoreMark(saved)
  call setpos(saved[0], saved[1])
endfunction

" escape the args so that can be feed to commandline or 'exec'
function! scripting#VimEscape(string, ...)
  let esc = a:0? a:1: get(g:, 'vim_cmdline_escape', '\ ')
  return escape(a:string, esc)
endfunction

function! scripting#CallFunction(Func, key)
  let F=function(a:Func)
  call F()
  return a:key
endfunction

function! scripting#GetMotionRange(type)
  if a:type=='line'
    return "'[V']"
  elseif a:type=='char'
    return "`[v`]"
  else
    return "`[\<C-V>`]"
  endif
endfunction