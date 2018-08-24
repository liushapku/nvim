function! buffer#tempname()
  let g:last_tempname = tempname()
  return g:last_tempname
endfunction

function! buffer#list()
  return airline#extensions#tabline#buflist#list()
endfunction

function! buffer#wipe_noname()
  for x in buffer#list()
    if bufname(x) == ''
      exe 'bw ' . x
    endif
  endfor
endfunction

" copied from airline#extensions#tabline#buffers.vim s:get_visible_buffers
" used by buffer#show
function! buffer#visible_list()
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

function! buffer#show(n)
  if a:n == 0
    b#
  endif
  let buflist = buffer#visible_list()
  if a:n >=1 && a:n <= len(buflist)
    silent exec 'b' . buflist[a:n-1]
  endif
endfunction

" next: go to next or previous
function! buffer#next(next)
  let term_autoinsert = g:term_autoinsert
  let g:term_autoinsert = 0
  try
    let buflist = buffer#list()
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
  finally
    let g:term_autoinsert = term_autoinsert
  endtry
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
  let switch= buffer#switch_to_buffer('neoterm-'.term)
  normal Gk
  let cline =  line('.')
  let line1 = search('^' . s . '\[' . anum . '\]', 'b')
  let line2 = search('^\(In \|Out\)')
  "echo cline line1 line2
  let lines = getline(line1, line2 - 1)
  call buffer#switch_back(switch)
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
    " let skip= 1
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

" switches to expr and returns [current_bufnr, current_winid, alternative_filename]
" if current == to, do nothing and return []
" if to-buffer is displayed: switch to its window, alternative_filename is not
" recorded
" else: switch to to-buf in current window, current_winid is set to -1
" result can be used in buffer#switch_back
function! buffer#switch_to_buffer(expr) abort
  let current = bufnr('%')
  let to = bufnr(a:expr)
  if current == to
    return []
  endif
  let win = bufwinid(to)
  if win == -1
    let alt = @#
    let current_winid = -1
    exe "b" to
  else
    let alt = ''
    let current_winid = win_getid()
    call win_gotoid(win)
  endif
  return [current, current_winid, alt]
endfunction
function! buffer#switch_back(result) abort
  if a:result == []
    return
  endif
  let [current, current_winid, alt] = a:result
  if current_winid != -1
    call win_gotoid(current_winid)
  else
    exe "b" current
    let @# = alt
  endif
endfunction

function! buffer#BufExec(bufexpr, ...) abort
  silent let switch = buffer#switch_to_buffer(a:bufexpr)
  call buffer#exe(a:000)
  silent call buffer#switch_back(switch)
endfunction

" returns [current win id], [nor current win nr]

function! buffer#arg_select(glob, type)
  let buflist = buffer#list()
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


function! buffer#exe(commands) abort
  let commands = split(join(a:commands, ' '), ';')
  for x in commands
    exec x
  endfor
endfunction

function! buffer#WinExecAll(...)
  for n in range(1, winnr('$'))
    call call('buffer#WinExec', [n] + a:000)
  endfor
endfunction


function! buffer#save_win_view()
" Save current view settings on a per-window, per-buffer basis.
  if !exists("w:SavedBufView")
    let w:SavedBufView = {}
  endif
  let w:SavedBufView[bufnr("%")] = winsaveview()
endfunction

" Restore current view settings.
function! buffer#restore_win_view()
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
  silent call buffer#save_win_view()
  try
    call buffer#exe(a:000)
  finally
    silent call buffer#restore_win_view()
  endtry
endfunction


function! buffer#RegExec(content, ...)
  echo a:content
  let temp = @+
  let @+ = a:content
  call buffer#exe(a:000)
  let @+ = temp
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
