function! window#NoSplitExec(command)
  exe 'below' a:command
  exe (winnr() -1) . 'wincmd c'
endfunction

" smart winnr
" handles +n, -n based on current winnr
" handles >n, <n which cycliclly advance or decrease winnr by n
" if expr is number 0 or "0", it is the same as >1
function! window#winnr(expr)
  let last = winnr('$')
  let expr = a:expr
  if expr is 0 || expr == "0"
    let expr = '>1'
  endif
  if expr is '$'
    return last
  elseif expr is '.' || expr is ''
    return winnr()
  elseif expr is '#'  "last accessed window
    return winnr('#')
  elseif expr[0] is '+'
    let n = expr[1:]
    let n = n == ''? 1 : n
    let next = winnr() + n
    let to = next > last? last : next
  elseif expr[0] is '-'
    let n = expr[1:]
    let n = n == ''? 1 : n
    let next = winnr() - n
    let to = next < 1 ? 1 : next
  elseif expr[0] is '>'
    let n = expr[1:]
    let n = n == ''? 1 : n
    let to = (winnr() + n) % last
    let to = to <= 0? to + last : to
  elseif expr[0] is '<'
    let n = expr[1:]
    let n = n == ''? 1 : n
    let to = (winnr() - n) % last
    let to = to <= 0 ? to + last : to
  else
    let to = str2nr(expr)
  endif

  if to > last
    return last
  elseif to < 1
    return 1
  else
    return to
  endif
endfunction

" switch to winid, returns [current_winid]
function! window#switch_to_winid(winid) abort
  if a:winid == []
    return []
  endif
  let winid = a:winid[0]
  let currentid = win_getid()
  if currentid == winid
    return []
  endif
  if win_gotoid(winid)
    return [currentid]
  endif
endfunction

" switch to winnr, if do not need to switch, returns []
" otherwise returns [current_winid]
function! window#switch_to_winnr(winnr) abort
  let currentnr = bufwinnr('%')
  let winnr = a:winnr > winnr('$')? 1: a:winnr
  if winnr == currentnr
    return []
  else
    let currentid = win_getid()
    exe winnr . "wincmd w"
    return [currentid]
  endif
endfunction

function! window#exec(winnr, ...)
  if &buftype == 'terminal'
    stopinsert
  endif
  " if winnr is 0, run in next win
  let winnr = window#winnr(a:winnr)
  silent let savewinid = window#switch_to_winnr(winnr)
  try
    call buffer#exe(a:000)
  finally
    silent call buffer#switch_to_winid(savewinid)
  endtry
endfunction

" swap two windows (the containing buffer), optionally keep the alternative
" buffer
function! window#swap_win(swap_alternative, n1, n2)
  let n1 = window#winnr(a:n1)
  let n2 = window#winnr(a:n2)
  if n1 == n2
    return
  endif
  let b1 = winbufnr(n1)
  let b2 = winbufnr(n2)
  if b1 == -1 || b2 == -1
    return
  endif
  call window#exec(n1, 'let s:temp1=bufnr(@#)')
  call window#exec(n2, 'let s:temp2=bufnr(@#)')
  let cmd1 = 'let @#=s:temp1'
  let cmd2 = 'let @#=s:temp2'
  let cmda = a:swap_alternative ? cmd2 : cmd1
  let cmdb = a:swap_alternative ? cmd1 : cmd2
  call window#exec(n1, 'silent b' . b2 . ';', cmda)
  call window#exec(n2, 'silent b' . b1 . ';', cmdb)
endfunction

function! s:winrestcmd(winnr, cmd, ...)
  if a:0 == 0
    exe a:cmd
  else
    let commands = split(a:cmd, '|')
    let N = len(commands) /2
    for n in a:000
      if n <= N && n > 0
        exe commands[2*n - 2]
        exe commands[2*n - 1]
      endif
    endfor
  endif
  exe a:winnr 'wincmd w'
endfunction

function! window#zoom(winnr, ...) abort
  echo a:winnr
  let winnr = a:winnr
  if winnr != winnr()
    exe winnr 'wincmd w'
  endif
  if exists('t:zoomed')
    call call('s:winrestcmd', [winnr(),  t:zoom_winrestcmd] + a:000)
    unlet t:zoomed
  else
    let t:zoom_winrestcmd = winrestcmd()
    resize
    vertical resize
    let t:zoomed = 1
  endif
endfunction

function! window#start_recording()
  echo "start recording macro to be executed in all windows. Press Q to cancel, press q to stop recording and run"

  let x = nr2char(getchar())
  if x !~# '^[a-zA-Z0-9"*+]$'
    return
  endif
  let s:macro_reg = x
  let s:macro_winnr = winnr()
  nnoremap q :<c-u>call window#StopRecording(0)<cr>
  nnoremap Q :<c-u>call window#StopRecording(1)<cr>
  exe "normal! q" . x
endfunction

function! window#stop_recording(cancel)
  normal! q
  nunmap q
  nnoremap Q :call window#start_recording()<cr>
  if !a:cancel
    let macro = getreg(s:macro_reg, 1)
    " the last q is recorded
    let macro = substitute(macro, "q$", "", "")
    call setreg(s:macro_reg, macro)
    call window#do_macro(s:macro_reg, 0)
  endif
endfunction

" do macro in windows
" window#do_macro(register, ns)
" if ns is a [n1, n2],  do in each winnr within the range
" otherwise do from next window and cycle back to current window
" if ns evals to true, the current window will be skipped
function! window#do_macro(reg, ns) abort
  if a:0 >= 1
    let n1, n2 = a:1
    for n in range(n1, n2)
      call window#switch_to_winnr(n)
      exe "normal @" . a:reg
    endfor
  else
    for n in range(ns? 2: 1, winnr('$'))
      call window#switch_to_winnr('>1')
      exe "normal @" . a:reg
    endfor
endfunction

" window line1 to line2 in window
function! window#show_lines(line1, line2) abort
  if a:line2 < a:line1
    return
  endif
  let nlines = a:line2 - a:line1 + 1
  exe nlines 'wincmd _'
  call winrestview({'topline': a:line1, 'lnum': a:line1})
endfunction

function! window#GotoView(mods, buf) abort
  if exists('w:sviewid') && w:sviewid != win_getid()
    let gotoid = win_gotoid(w:sviewid)
    "echo gotoid a:buf bufname(a:buf) '|' a:mods @%
    "echo a:buf bufname(a:buf) bufname(79)
    if gotoid == 1 && a:buf != ''
      exe 'b' a:buf
    endif
  else
    if exists('w:sviewid')
      unlet w:sviewid
    endif
    if a:buf == ''
      exe a:mods 'split'
    else
      exe a:mods 'sb' a:buf
    endif
  endif
  let winid = win_getid()
  return winid
endfunction

" window#preview(mods, line1, line2[, buf, line1, line2])
" the second line1 and line2, if exists,  overwrites the first
" the first is retrived from command-range, which cannot exceed the lines for
" current buffer. Thus, if we need preview another buffer, the second line1
" and line2 can be used
function! window#preview(mods, line1, line2, ...) abort
  let buf = a:0 > 0 ? a:000[0] : ''
  let buf = buf == '.' ? '': buf
  let line1 = a:0 > 1 ? a:000[1] : a:line1
  let line2 = a:0 > 2 ? a:000[2] : (a:0 > 1 ? a:000[1] : a:line2)

  let cmd = winsaveview()
  exe a:mods 'pedit' bufname(buf)
  wincmd P
  call window#show_lines(line1, line2)
  wincmd p
  call winrestview(cmd)
endfunction

" this is a window local view (each window can have one different view,
" we can only have 1 preview window)
" the id is saved in w:sviewid
function! window#splitview(mods, line1, line2, ...) abort
  echo a:000
  let buf = a:0 > 0 ? a:000[0] : ''
  let buf = buf == '.' ? '': buf
  let line1 = a:0 > 1 ? a:000[1] : a:line1
  let line2 = a:0 > 2 ? a:000[2] : (a:0 > 1 ? a:000[1] : a:line2)

  let cmd = winsaveview()
  let winid = window#GotoView(a:mods, buf)
  call window#show_lines(line1, line2)
  wincmd p
  let w:sviewid = winid
  call winrestview(cmd)
endfunction

" close the nth view of current window
function! window#CloseView()
  if exists('w:sviewid')
    exe win_id2win(w:sviewid) 'wincmd c'
    unlet w:sviewid
  endif
endfunction

function! window#SetViewId(winnr) abort
  if a:winnr is '' && exists('w:sviewid')
    unlet w:sviewid
  else
    let w:sviewid = win_getid(a:winnr)
  endif
endfunction

function! window#SetTop(line) abort
  let line = a:line == 0 ? line('.') : a:line
  call winrestview({'topline': line, 'lnum': line})
endfunction

function! window#CloseHoldPrevious(nr, reverse) abort
  echo a:nr
  if a:nr == 1 && !a:reverse
    1wincmd c
    return
  elseif a:nr == winnr('$') && a:reverse
    $wincmd c
    return
  endif
  let winnr1 = a:reverse? a:nr + 1 : a:nr - 1
  let winid1 = win_getid(winnr1)
  exe winnr1 . 'wincmd w'
  let fixwidth = &winfixwidth
  let fixheight = &winfixheight
  set winfixwidth winfixheight
  wincmd p
  exe a:nr . 'wincmd c'
  let winnr1 = win_id2win(winid1)
  exe winnr1 . 'wincmd w'
  let &winfixwidth = fixwidth
  let &winfixheight = fixheight
  wincmd p

endfunction

function! window#MatrixSplit(...) abort
  silent only
  if a:0 == 1
    let ncol = a:1
    let nrow = 1
  elseif a:0 == 2
    let ncol = a:2
    let nrow = a:1
  else
    echoerr 'wrong input'
  endif
  if ncol < 1 || nrow < 1
    echoerr 'wrong input'
  endif

  let temp=@a
  if ncol > 1
    let @a = "\<c-w>v"
    exe "normal " . (ncol -1) . "@a"
  endif
  if nrow > 1
    let @a = "\<c-w>s"
    windo exe "normal " . (nrow -1). "@a"
  endif
  wincmd =
  1wincmd w
  let @a=temp
endfunction

function! window#EditArg(...)
  if a:0 == 0
    let list = range(1, len(argv()))
  else
    let list = a:000
  endif
  let nwin = winnr('$')
  let nfile = len(list)
  let n = min([nfile, nwin])
  for i in range(1, n)
    silent exe i "wincmd w"
    silent! exe "argument" list[i-1]
  endfor
  1 wincmd w
endfunction

