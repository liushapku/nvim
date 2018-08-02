function! buffer#BufferList()
    return airline#extensions#tabline#buflist#list()
endfunction
function! buffer#NeotermList() abort
    let bufnrs = []
    let neoterms = []
    for b in airline#extensions#tabline#buflist#list()
        let name = bufname(b)
        if name =~ '^term://'
            call add(bufnrs, b)
            if name =~ 'neoterm-[0-9]\+$'
                call add(neoterms, substitute(name, '.*neoterm-\([0-9]\+\)$', '\1', ''))
            endif
        endif
    endfor
    return [bufnrs, sort(neoterms)]
endfunction

" copied from airline#extensions#tabline#buffers.vim s:get_visible_buffers
" used by buffer#BufferAt
function! buffer#VisibleBufferList()
  let buffers = airline#extensions#tabline#buflist#list()
  let cur = bufnr('%')

  let total_width = 0
  let max_width = 0

  for nr in buffers
    let width = len(airline#extensions#tabline#get_buffer_name(nr)) + 4
    let total_width += width
    let max_width = max([max_width, width])
  endfor

  " only show current and surrounding buffers if there are too many buffers
  let position  = index(buffers, cur)
  let vimwidth = &columns
  if total_width > vimwidth && position > -1
    let buf_count = len(buffers)

    " determine how many buffers to show based on the longest buffer width,
    " use one on the right side and put the rest on the left
    let buf_max   = vimwidth / max_width
    let buf_right = 1
    let buf_left  = max([0, buf_max - buf_right])

    let start = max([0, position - buf_left])
    let end   = min([buf_count, position + buf_right])

    " fill up available space on the right
    if position < buf_left
      let end += (buf_left - position)
    endif

    " fill up available space on the left
    if end > buf_count - 1 - buf_right
      let start -= max([0, buf_right - (buf_count - 1 - position)])
    endif

    let buffers = eval('buffers[' . start . ':' . end . ']')
  endif
  return buffers
endfunction



function! buffer#BufferAt(n)
    if a:n == 0
        b#
    endif
    let buflist = buffer#VisibleBufferList()
    if a:n >=1 && a:n <= len(buflist)
        silent exec 'b' . buflist[a:n-1]
    endif
endfunction
function! buffer#BufferNext(next)
    let term_auto_insert = g:term_auto_insert
    let g:term_auto_insert = 0
    let buflist = buffer#BufferList()
    let cb = bufnr('%')
    let idx = index(buflist, cb)
    if a:next
        if idx < len(buflist)-1 && idx >=0
            silent exec 'b' . buflist[idx+1]
        else
            silent exec 'b' . buflist[0]
        endif
    else
        if idx < len(buflist) && idx >0
            silent exec 'b' . buflist[idx-1]
        else
            silent exec 'b' . buflist[-1]
        endif
    endif
    let g:term_auto_insert = term_auto_insert
endfunction

function! buffer#NextNeoterm(start)
    " find next term buffer from start
    let [bufnrs, neoterms] = buffer#NeotermList()
    if len(neoterms) == 0
        return 0
    endif
    let start = a:start == 0? g:current_neoterm : a:start
    for n in neoterms
        if n> start
            return n
        endif
    endfor
    return neoterms[0]
endfunction

" change current window to neoterm
" optional argument: if exist, search in reverse order
" if num > 0: goto neoterm-num
" if num == 0 && current buffer is not terminal: goto current_buf_term
" if current buf is a terminal: go to next terminal buffer
function! buffer#GoToNeoterm(num) abort
    if a:num > 0
        exec "buffer neoterm-" . a:num
    elseif &buftype == 'terminal'
        if !exists('g:current_neoterm')
            Topen
            return
        endif
        let next = buffer#NextNeoterm(0)
        exec "buffer neoterm-" . next
        return
    else
        exec "buffer neoterm-" . g:current_neoterm
    endif
endfunction

" switch to neoterm
" if current_buf_term is not shown or current_buf_term is the current window, use current window
" else: go to window of current_buf_term and switch that window to a new
" neoterm
function! buffer#SwitchNeoterm(num) abort
    let cwin = winnr()
    let win = bufwinnr('neoterm-' .g:current_neoterm)
    if win == -1
        let num = a:num == 0? g:current_neoterm : a:num
        call buffer#GoToNeoterm(num)
        return
    elseif win == cwin
        let num = a:num ==0? buffer#NextNeoterm(0) : a:num
        call buffer#GoToNeoterm(num)
        return
    elseif a:num != g:current_neoterm
        let num = a:num ==0? buffer#NextNeoterm(0) : a:num
        silent let sw = buffer#SwitchToWinnr(win)
        call buffer#GoToNeoterm(num)
        silent call buffer#SwitchToWinid(sw)
    endif
endfunction

function! buffer#CloseNeoterm(num)
    let num = a:num == 0 ? g:current_neoterm : a:num
    let win = bufwinid('neoterm-'.num)
    if win == -1
        return
    endif
    let cwin = win_getid()
    if cwin != win
        call win_gotoid(win)
    endif
    silent! close
    if cwin != win
        call win_gotoid(cwin)
    endif
endfunction

function! buffer#OpenNeoterm(num)
    let num = a:num == 0 ? g:current_neoterm : a:num
    let win = bufwinnr('neoterm-' . num)
    if win == -1
        exe 'RIGHT neoterm-' . num
    else
        exe win . 'wincmd w'
    endif
endfunction

function! buffer#ToggleNeoterm(num)
    let num = a:num == 0 ? g:current_neoterm : a:num
    let win = bufwinid('neoterm-' . num)
    if win == -1
        exe 'RIGHT neoterm-' . num
        wincmd p
    else
        let cwin = win_getid()
        if cwin != win
            call win_gotoid(win)
        endif
        silent! close
        if cwin != win
            call win_gotoid(cwin)
        endif
    endif
endfunction



function! buffer#TermsToTab() abort
    let switchbuf = &switchbuf
    set switchbuf-=useopen

    let terms = buffer#NeotermList()
    let nrs = terms[0]
    if len(nrs) == 0
        return
    endif

    exe 'tab sb' nrs[0]
    for i in nrs[1:]
        exe 'vert sb' i
    endfor
    normal =
    let &switchbuf = switchbuf
endfunction

function! buffer#BufList() abort
    return airline#extensions#tabline#buflist#list()
endfunction


function! buffer#BufNr(idx) abort
    return airline#extensions#tabline#buflist#list()[a:idx-1]
endfunction

function! buffer#DeleteNeoterm(...) abort
    let [buflist, omit] = buffer#NeotermList()
    if a:0 == 0
        for b in buflist
            exec "bd! " . b
        endfor
    else
        for aa in a:000
            let pattern = 'neoterm-' . aa . '$'
            for b in buflist
                let name = bufname(b)
                if name =~ pattern
                    "echo 'bufnr:' b ':' name
                    exec "bd! " . b
                    if aa == g:current_neoterm
                        let g:current_neoterm = buffer#NextNeoterm()
                    endif
                    break
                endif
            endfor
        endfor
        if g:current_neoterm == 0
            unlet g:current_neoterm
        endif
    endif
endfunction

function! buffer#Reopen()
    silent! argdelete *
    for i in buffer#BufferList()
        if bufname(i) !~ '^term:'
            exec 'argadd ' . bufname(i)
            exec 'bw ' . i
        endif
    endfor
    argdo e
endfunction

function! buffer#WipeNoName()
    for x in buffer#BufList()
        if bufname(x) == ''
            exe 'bw ' . x
        endif
    endfor
endfunction

function! buffer#CopyIPython(bang, ...)
    if a:0 > 0
        if a:1[-1:] == 'i'
            let anum = a:1[:-2]
            let s = 'In '
        elseif a:1[-1:] == 'o'
            let anum = a:1[:-2]
            let s = 'Out'
        else
            let anum = a:1
            let s = '\(In \|Out\)'
        endif
        if anum == ''
            let anum = '\d\+'
        endif
    else
        let anum = '\d\+'
        let s = '\(In \|Out\)'
    endif

    let term = g:current_neoterm

    let olda = @a
    let switch= buffer#SwitchToBuffer('neoterm-'.term)
    normal Gk
    let cline =  line('.')
    let line1 = search('^' . s . '\[' . anum . '\]', 'b')
    let line2 = search('^\(In \|Out\)')
    "echo cline line1 line2
    let lines = getline(line1, line2 - 1)
    call buffer#SwitchBack(switch)
    let out = []
    let str2 = s == 'In ' && a:bang ? '>>> ': ''
    let skip = 0
    let multi_in = 0
    for l in lines
        let l = substitute(l, '^' . s . '\[\d\+\]:\s*', str2, '')
        if l =~ '^ *\.\.\.: '
            let l = substitute(l, '^ *\.\.\.: ', a:bang? '... ':'', 'g')
            "let l = substitute(l, '^ *\.\.\.:', '', 'g')
            let multi_in = 1
        "elseif multi_in
        "    let skip= 1
        endif
        if l == '%paste'
            let skip= 1
            continue
        elseif l == '## -- End pasted text --'
            let skip= 0
            continue
        endif
        if skip == 0
            if ! ((len(out) == 0 || out[-1] == '') && len(l) == 0)
                call add(out, l)
            endif
        endif
    endfor
    return out
endfunction


" if <bang>, use cpaste
function! buffer#SendToIPython(ipython, bang) range abort
  call neoterm#repl#handlers()  " only to load the autoload module
  let lines = getline(a:firstline, a:lastline)
  let old = @+
  let @+ = join(lines, "\n")
  call g:neoterm.repl.exec(['%paste'])
  return
endfunction

" switches to expr and returns [current_bufnr, current_winid, alternative_filename]
" if current == to, do nothing and return []
" if to-buffer is displayed: switch to its window, alternative_filename is not
" recorded
" else: switch to to-buf in current window, current_winid is set to -1
" result can be used in buffer#SwitchBack
function! buffer#SwitchToBuffer(expr) abort
    let current = bufnr('%')
    let to = bufnr(a:expr)
    if current == to
        return []
    endif
    let win = bufwinid(to)
    if win == -1
        let alt = @#
        let current_win = -1
        exe "b" to
    else
        let alt = ''
        let current_win = win_getid()
        call win_gotoid(win)
    endif
    return [current, current_win, alt]
endfunction
function! buffer#SwitchBack(result) abort
    if a:result == []
        return
    endif
    let [current, current_win, alt] = a:result
    if current_win != -1
        call win_gotoid(current_win)
    else
        exe "b" current
        let @# = alt
    endif
endfunction

function! buffer#BufExec(bufexpr, ...) abort
    silent let switch = buffer#SwitchToBuffer(a:bufexpr)
    call buffer#Exec(a:000)
    silent call buffer#SwitchBack(switch)
endfunction

" returns [current win id], [nor current win nr]
function! buffer#SwitchToWinnr(winnr) abort
    let current = bufwinnr('%')
    let winnr = a:winnr > winnr('$')? 1: a:winnr
    if winnr == current
        return []
    else
        let currentid = win_getid()
        exe winnr . "wincmd w"
        return [currentid]
    endif
endfunction

function! buffer#Select(glob, type)
    let buflist = buffer#BufferList()
    let result = []
    for x in buflist
        let name = bufname(x)
        if name =~ glob2regpat(a:glob)
            call add(result, name)
        endif
    endfor
    if a:type == 'args'
        exe 'args ' . join(result)
    elseif a:type == 'replace'
        argdelete *
        exe 'argadd ' . join(result)
    elseif a:type == 'append'
        exe 'argadd ' . join(result)
    elseif a:type == 'local'
        exe 'arglocal! ' . join(result)
    endif
    return result
endfunction

function! buffer#ArgSet(list, islocal)
    if islocal
        exe 'arglocal! ' . join(a:list)
    end
        argdelete *
        exe 'argadd ' . join(a:list)
    endif
endfunction


function! buffer#SwitchToWinid(winid) abort
    if a:winid == []
        return []
    endif
    let winid = a:winid[0]
    let current = win_getid()
    if current == winid
        return []
    endif
    if win_gotoid(winid)
        return [current]
    endif
endfunction

function! buffer#Exec(commands) abort
    let commands = split(join(a:commands, ' '), ';')
    for x in commands
        exec x
    endfor
endfunction

function! buffer#WinExec(winnr, ...)
    " if winnr is 0, run in next win
    let winnr = window#Winnr(a:winnr)
    silent let sw = buffer#SwitchToWinnr(winnr)
    if &buftype == 'terminal'
        stopinsert
    endif
    call buffer#Exec(a:000)
    silent call buffer#SwitchToWinid(sw)
endfunction
function! buffer#WinExecAll(...)
    for n in range(1, winnr('$'))
        call call('buffer#WinExec', [n] + a:000)
    endfor
endfunction


function! buffer#AutoSaveWinView()
" Save current view settings on a per-window, per-buffer basis.
    if !exists("w:SavedBufView")
        let w:SavedBufView = {}
    endif
    let w:SavedBufView[bufnr("%")] = winsaveview()
endfunction

" Restore current view settings.
function! buffer#AutoRestoreWinView()
    let buf = bufnr("%")
    if exists("w:SavedBufView") && has_key(w:SavedBufView, buf)
        let v = winsaveview()
        let atStartOfFile = v.lnum == 1 && v.col == 0
        if atStartOfFile && !&diff
            call winrestview(w:SavedBufView[buf])
        endif
        unlet w:SavedBufView[buf]
    endif
endfunction

function! buffer#ViewExec(...)
    silent call buffer#AutoSaveWinView()
    call buffer#Exec(a:000)
    silent call buffer#AutoRestoreWinView()
endfunction


function! buffer#RegExec(content, ...)
    echo a:content
    let temp = @+
    let @+ = a:content
    call buffer#Exec(a:000)
    let @+ = temp
endfunction

function! buffer#NeotermAllDo(args)
    for i in keys(g:neoterm.instances)
        call g:neoterm.instances[i].do(a:args)
    endfor
endfunction

function! buffer#NeotermJobid(num)
    let num = a:num == 0?g:current_neoterm: a:num
    return g:neoterm.instances[num].job_id
endfunction

" change the cwd and cwd of the embed terminals to dir
" if dir is a file, change to its containing dir
function! buffer#Cd(dir, notall)
    let dir = len(a:dir) == 0? getcwd(): a:dir
    if empty(glob(dir))
        echoerr dir . ' does not exist'
        return
    endif
    if !isdirectory(dir)
        let dir = fnamemodify(dir, ':p:h')
    endif
    exe "cd" dir
    exe ((a:notall? "T": "TA") . ' cd ' . dir)
endfunction
function! buffer#TogglePlug(name)
    let fname = len(a:name) == ''? expand('%:p') : a:name
    if fname =~# 'plugin'
        let fname = substitute(fname, 'plugin', 'autoload', '')
    elseif fname =~# 'autoload'
        let fname = substitute(fname, 'autoload', 'plugin', '')
    else
        return
    endif
    exe "edit" fname
endfunction
function! buffer#ToggleFtPlug(name)
    let fname = len(a:name) == ''? expand('%:p') : a:name
    if fname =~# 'ftplugin'
        let fname = substitute(fname, 'ftplugin', 'autoload', '')
    elseif fname =~# 'autoload'
        let fname = substitute(fname, 'autoload', 'ftplugin', '')
    else
        return
    endif
    exe "edit" fname
endfunction

function! buffer#Tempname()
    let g:last_tempname = tempname()
    return g:last_tempname
endfunction

