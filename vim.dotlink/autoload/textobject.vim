
function! s:FindLineLen(type, backward)
  let cline = line('.')
  let ccol = col('.')
  let length = len(getline(cline))
  "echo cline ccol

  if a:backward
    let lines = range(cline, 1, -1)
  else
    let lines = range(cline, line('$'))
  endif
  for x in lines
    let diff = len(getline(x)) - length
    if (a:type == '<' && diff < 0) || (a:type == '>' && diff > 0) || (a:type == '=' && diff != 0)
      if a:backward && cline - x - 1 > 0
        return (cline - x - 1) . "k"
      elseif !a:backward && x - cline - 1 > 0
        return (x - cline -1) . "j"
      else
        return ""
      endif
      break
    endif
  endfor
  return ""
endfunction

" define a visual mode motion and operator pending mode motion
" NOTE: use :command in visual mode will enter normal mode and the cursor
" position will be restored. So we need to use <expr> map
function! textobject#define(mapstr, command, mode)
  let mode = a:mode is ""? "[nvo]":"[" . a:mode . "]"
  if "n" =~# mode
    exe "nmap <expr>" a:mapstr a:command
  endif
  if "v" =~# mode
    exe "vmap <expr>" a:mapstr a:command
  endif
  if "o" =~# mode
    exe "omap" a:mapstr ":normal V" . a:mapstr '<cr>'
  endif
endfunction

function! textobject#define_all(list)
  for x in a:list
    let [mapstr, acommand] = x[:2]  " allow the rest to be comments
    let amode = len(x) > 2? x[2] : ""
    call textobject#define(mapstr, acommand, amode)
  endfor
endfunction

" if mode() matches from, then change to to
function! s:ChangeMode(from, to)
  return mode() =~! a:from? a:to : ""
endfunction
function! textobject#change_mode(from, to)
  return s:ChangeMode(from, to)
endfunction

function! textobject#show_position()
  echo getpos("'<") getpos("'>") getpos(".") getpos("v") getcurpos()
  return ""
endfunction

function! textobject#mode()
  echo mode()
  return ""
endfunction
