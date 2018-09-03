
function! textobject#find_line_length(type, backward)
  let cline = line('.')
  let ccol = len(getline(cline))

  if a:backward
    let lines = range(cline, 1, -1)
  else
    let lines = range(cline, line('$'))
  endif
  for x in lines
    let diff = len(getline(x)) - ccol
    "echo x len(getline(x)) ccol diff a:type
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
    call setpos("'<", [0, x, ccol, 0])
    "echo "normal" x . "G"
    "pxe "normal" x . "G"
  else
    call setpos("'>", [0, x, ccol, 0])
    "echo "normal" x . "G"
    "exe "normal" x . "G"
  endif
endfunction

" define a visual mode motion and operator pending mode motion
function! textobject#define(mapstr, command)
  exe "vmap" a:mapstr a:command
  exe "omap" a:mapstr ":normal v" . a:mapstr . "<cr>"
endfunction
