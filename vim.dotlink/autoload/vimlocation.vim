function! vimlocation#command(command)
  let acommand = a:command == ''? expand("<cword>") : a:command
  let ret = split(Redir('verb comm ' . acommand), "\n")
  for x in range(1, len(ret) - 1)
    if ret[x] =~ '\<' . acommand . '\>\s\+'
      return substitute(ret[x+1], '\s*Last set from ', '', '')
    endif
  endfor
endfunction
function! vimlocation#edit_command(mods, pedit, command)
  let file = vimlocation#command(a:command)
  if file == ''
    return
  endif
  if a:pedit
    exe a:mods 'pedit' file
    wincmd P
  elseif !empty(a:mods)
    exe a:mods 'new' file
  else
    exe 'edit' file
  endif
  call search('^com.*\<'. a:command . '\>')
  if a:pedit
    normal zt
  else
    normal zz
  endif
endfunction

function! vimlocation#map(type, command, index)
  let acommand = a:command == ''? expand("<cword>") : a:command
  let ret = split(Redir('verb ' . a:type . 'map ' . acommand), "\n")
  if len(ret) == 2
    return substitute(ret[1], '\s*Last set from ', '', '')
  elseif a:index > 0
    return substitute(ret[2*a:index -1], '\s*Last set from ', '', '')
  else
    echoerr 'more than one match, please specify an index'
  endif
  return ''
endfunction
function! vimlocation#edit_map(mods, pedit, type, command, ...)
  let acommand = a:command
  if a:0 == 0
    let index = 0
  else
    let index = a:1
  endif
  let file = call('vimlocation#map', [a:type, acommand, index])
  if file == ''
    echo a:type acommand file
    return
  endif
  let command = acommand[0] == ';'? ('\(<leader>\|;\)' . acommand[1:]) : acommand
  let pattern = '^\c.*map .*' . command . ' '
  if a:pedit
    exe a:mods 'pedit' file
    wincmd P
  elseif !empty(a:mods)
    exe a:mods 'new' file
  else
    exe 'edit' file
  endif
  call search(pattern,  '')
  if a:pedit
    normal zt
  else
    normal zz
  endif
endfunction

function! vimlocation#function(functionname)
  try
    let ret = split(Redir('verb function ' . a:functionname), "\n")
    return substitute(ret[1], '\s*Last set from ', '', '')
  catch
    echoerr v:exception
    echoerr 'function not found'
    return ''
  endtry
endfunction

function! vimlocation#edit_function(mods, pedit, function)
  let afunction = a:function == ''? expand("<cword>") : a:function
  let file = vimlocation#function(afunction)
  echo file
  if file == ''
      return
  endif
  if a:pedit
    exe a:mods 'pedit' file
    wincmd P
  elseif !empty(a:mods)
    exe a:mods 'new' file
  else
    exe 'edit' file
  endif
  call search('^function!\?\s\+\<'. afunction . '\>')
  if a:pedit
    normal zt
  else
    normal zz
  endif
endfunction

