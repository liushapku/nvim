
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

":h map-expression
" NOW we can use Cmd map, see :h map-cmd
"Be very careful about side effects!  The expression is evaluated while
"obtaining characters, you may very well make the command dysfunctional.
"For this reason the following is blocked:
"- Changing the buffer text |textlock|.
"- Editing another buffer.
"- The |:normal| command.
"- Moving the cursor is allowed, but it is restored afterwards.
"- If the cmdline is changed, the old text and cursor position are restored.
"If you want the mapping to do any of these let the returned characters do
"that. Or use a |<Cmd>| mapping (which doesn't have these restrictions).
function! textobject#define_all(list)
  for x in a:list
    let [mapstr, acommand] = x[:1]  " allow the rest to be comments
    let amode = get(x, 2, "")
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
