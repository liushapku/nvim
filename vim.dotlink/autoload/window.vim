
function! window#NoSplitExec(command)
    exe 'below' a:command
    exe (winnr() -1) . 'wincmd c'
endfunction

function! window#SwapWith(n)

    if a:n == 0
        let next = winnr() + 1
        let next = next > winnr('$')? 1: next
    else
        let next = a:n
    endif
    let tab = tabpagenr()
    call WindowSwap#SetMarkedWindowNum(tab, next)
    call WindowSwap#DoWindowSwap()
endfunction

function! window#Winnr(expr)
    let last = winnr('$')
    if a:expr == '$'
        return last
    elseif a:expr == '#'
        return winnr('#')
    elseif a:expr == '.' || a:expr == ''
        return winnr()
    elseif a:expr[0] == '+'
        let n = a:expr[1:]
        let n = n == ''? 1 : n
        let next = winnr() + n
        let to = next > last? last : next
    elseif a:expr[0] == '-'
        let n = a:expr[1:]
        let n = n == ''? 1 : n
        let next = winnr() - n
        let to = next < 1 ? 1 : next
    elseif a:expr[0] == '>'
        let n = a:expr[1:]
        let n = n == ''? 1 : n
        let to = (winnr() + n) % last
        let to = to <= 0? to + last : to
    elseif a:expr[0] == '<'
        let n = a:expr[1:]
        let n = n == ''? 1 : n
        let to = (winnr() - n) % last
        let to = to <= 0 ? to + last : to
    else
        let to = a:expr
    endif

    if to > last
        return last
    elseif to < 1
        return 1
    else
        return to
    endif
endfunction


function! window#SwapWin(swap_alternative, n1, ...)
    let n = winnr()
    let n1 = a:n1 == 0? winnr(): a:n1
    let n2 = a:0  == 0 || a:1 == 0 ? winnr() : a:1
    if n1 == n2
        return
    endif
    let b1 = winbufnr(n1)
    let b2 = winbufnr(n2)
    if b1 == -1 || b2 == -1
        return
    endif
    call buffer#WinExec(n1, 'let s:temp1=bufnr(@#)')
    call buffer#WinExec(n2, 'let s:temp2=bufnr(@#)')
    let cmd1 = 'let @#=s:temp1'
    let cmd2 = 'let @#=s:temp2'
    let cmda = a:swap_alternative ? cmd2 : cmd1
    let cmdb = a:swap_alternative ? cmd1 : cmd2
    call buffer#WinExec(n1, 'silent b' . b2 . ';', cmda)
    call buffer#WinExec(n2, 'silent b' . b1 . ';', cmdb)
endfunction

function! window#RunWinRestCmd(winnr, cmd, ...)
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

function! window#ZoomToggle(winnr, ...) abort
    echo a:winnr
    let winnr = a:winnr
    if winnr != winnr()
        exe winnr 'wincmd w'
    endif
    if exists('t:zoomed') && t:zoomed
        call call('window#RunWinRestCmd', [winnr(),  t:zoom_winrestcmd] + a:000)
        unlet t:zoomed
    else
        let t:zoom_winrestcmd = winrestcmd()
        resize
        vertical resize
        let t:zoomed = 1
    endif
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

function! window#StartRecording()
    let x = nr2char(getchar())
    if x !~# '^[a-zA-Z0-9"*+]$'
        return
    endif
    let s:macro_reg = x
    nnoremap q :<c-u>call window#StopRecording(0)<cr>
    nnoremap Q :<c-u>call window#StopRecording(1)<cr>
    exe "normal! q" . x
endfunction


function! window#StopRecording(cancel)
    normal! q
    nunmap q
    nnoremap Q :call window#StartRecording()<cr>
    let macro = getreg(s:macro_reg)
    " the last q is recorded
    let macro = substitute(macro, "q$", "", "")
    call setreg(s:macro_reg, macro)
    if !a:cancel
        call window#MacroDo(s:macro_reg)
    endif
endfunction

function! window#MacroDo(reg) abort
    for n in range(2, winnr('$'))
        wincmd w
        exe "normal @" . a:reg
    endfor
endfunction

" window line1 to line2 in window
function! window#Show(line1, line2) abort
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

function! window#Preview(mods, line1, line2, ...) abort
    let buf = a:0 > 0 ? a:000[0] : ''
    let buf = buf == '.' ? '': buf
    let line1 = a:0 > 1 ? a:000[1] : a:line1
    let line2 = a:0 > 2 ? a:000[2] : (a:0 > 1 ? a:000[1] : a:line2)

    let cmd = winsaveview()
    exe a:mods 'pedit' bufname(buf)
    wincmd P
    call window#Show(line1, line2)
    wincmd p
    call winrestview(cmd)
endfunction

function! window#Splitview(mods, line1, line2, ...) abort
    echo a:000
    let buf = a:0 > 0 ? a:000[0] : ''
    let buf = buf == '.' ? '': buf
    let line1 = a:0 > 1 ? a:000[1] : a:line1
    let line2 = a:0 > 2 ? a:000[2] : (a:0 > 1 ? a:000[1] : a:line2)

    let cmd = winsaveview()
    let winid = window#GotoView(a:mods, buf)
    call window#Show(line1, line2)
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

function! window#CloseHoldLeftOrBelow(nr, reverse) abort
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
