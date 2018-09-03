
function! textobject#find_line_length(type, backward, select)
  let cline = a:backward? getpos("'<")[1]: getpos("'>")[1]
  let ccol = a:backward? getpos("'<")[2]: getpos("'>")[2]
  let length = len(getline(cline))

  if a:backward
    let lines = range(cline, 1, -1)
  else
    let lines = range(cline, line('$'))
  endif
  for x in lines
    let diff = len(getline(x)) - length
    if a:type == 'shorter' && diff < 0
      let x = a:backward? x+1: x-1
      break
    elseif a:type == 'longer' && diff > 0
      let x = a:backward? x+1: x-1
      break
    elseif a:type == 'equal' && diff != 0
      let x = a:backward? x+1: x-1
      break
    endif
  endfor
  if a:backward
    let saveother = getpos("'>")
    call setpos("'<", [0, x, ccol, 0])
    call setpos("'>", saveother)
  else
    let saveother = getpos("'<")
    call setpos("'>", [0, x, ccol, 0])
    call setpos("'<", saveother)
  endif
  if a:select
    execute "normal gv" . (a:backward?'o':'')
  endif
endfunction

" define a visual mode motion and operator pending mode motion
function! textobject#define(mapstr, command)
  exe "vmap" a:mapstr a:command
  exe "omap" a:mapstr ":normal V" . a:mapstr . "<cr>"
endfunction
