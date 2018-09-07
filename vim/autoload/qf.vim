
" qf#SetQF(lines[, option_dic])
" option_dic: key:
"   nojump: do not jump, default 0
function! qf#SetQF(data, ...) abort
  let workspacepat = substitute($WORKSPACE, 'workspace[0-9]', 'workspace[0-9]', '')
  let workspacetarget = $WORKSPACE
  if a:data is ''
    call setqflist([], 'r')
    cclose
    return
  endif
  let opts = a:0 == 0? {} : a:1
  let nojump = get(opts, 'nojump', 0)
  let data = type(a:data) == v:t_string?  split(a:data, "\n") : a:data
  let qflist = filter(data, 'v:val != ""')
  let qflist = map(qflist, 'substitute(v:val, "^/site/home", "/home", "")')
  let qflist = map(qflist, 'substitute(v:val, workspacepat, workspacetarget, "")')
  "echo join(qflist, "\n") . "\n"
  let oldefm = &efm
  let &efm = get(opts, 'efm', &efm)
  let position = get(opts, 'location', 'quickfix')
  let cmd = position == 'quickfix'? 'cexpr qflist' : 'lexpr qflist'

  try
    if position == 'quickfix'
      cexpr qflist
    else
      lexpr qflist
    endif
    bo cw
    if nojump
      wincmd p
    else
      exec "normal \<cr>"
    endif
  finally
    let &efm = oldefm
  endtry
endfunction

function! qf#GetQFFromNeoterm(type, ...) abort
  let bufid = g:neoterm.repl.instance().buffer_id
  let switch=buffer#SwitchToBuffer(bufid)
  let temp = @"
  normal G
  silent normal :?Traceback?+1;/^\(\d\+: \)\?\s*\S\+Error/y "
  call buffer#SwitchBack(switch)
  if a:type == 'ipython'
      let msg = substitute(@", "\n\n", "\n\n[FILE]:", "g")
      let msg = "[FILE]:" . msg
      let efm = g:efm_python_ipython
  elseif a:type == 'python'
      let msg = string#SearchAndSubstitute(@", '\(\d\+: \)\?  File .*, line \d\+, in \w\+', "$", '():', '')
      let efm = g:efm_python
  else
      let msg = @"
      let efm = &efm
  endif
  call SetQF(msg, {'efm': efm})
  let @"=temp
  bo cw
  let opts = get(a:000, 0, {})
  let nojump = get(opts, 'nojump', 0)
  echo nojump
  if nojump
    wincmd p
  else
    normal "\<cr>"
  endif
endfunction

function! qf#LocateQF()
  let l1 = search('Traceback', 'b')
  if l1 == 0
    echoerr 'LocateQF: cannot find traceback'
    return ''
  endif
  let l2 = search('^\(\d\+: \)\?\S\+Error', 'W')
  if l2 == 0
    echoerr 'LocateQF: cannot find traceback'
    return ''
  endif
  return getline(l1+1, l2)
endfunction

function! qf#Search(pat, backward, mode)
  let lstinfo = getqflist({'winid':1, 'items':1})
  let lst = lstinfo['items']
  let winid = lstinfo['winid']
  for i in range(len(lst))
    let bufnr = lst[i].bufnr
    if a:mode == 'file'
      let match = (bufnr != 0 && bufname(bufnr) =~# a:pat)
    elseif a:mode == 'text'
      let match = lst[i].text =~# a:pat
    else
      let match = (bufnr != 0 && bufname(bufnr) =~# a:pat) || lst[i].text =~# a:pat
    endif
    if match
      exec "cc" (i+1)
      break
    endif
  endfor
endfunction

function! qf#CleanPythonDoctestResult(lines) abort
  let out = []
  let mode = ''
  for line in a:lines[1:]
    if line =~# '^FAIL: Doctest:'
      call add(out, line)
    elseif line =~# '^File'
      let save = line
    elseif line =~# '^Failed example'
      let mode = 'example'
    elseif line =~# '^Got:'
      let mode = 'got'
      call add(out, save . ' >>> Unmatched result:')
    elseif line == 'Exception raised:'
      let mode = 'except'
      let idx = len(out)
      call add(out, 'Exception: ' . save)
    elseif line =~# '^===\+$'
      if mode == 'except'
        call add(out, '')
      endif
      let mode = ''
    elseif line =~# '^---\+$'
      if mode == 'except'
        call add(out, '')
      endif
      let mode = ''
    elseif line == ''
      continue
    elseif mode == 'got'
      call add(out, line)
    elseif mode == 'except'
      if line =~# '^      File'
        call add(out, line[6:])
      elseif line =~# '^        \w'
        let out[-1] = out[-1] . ' >>> ' . line[8:]
      elseif line =~# '^    \w\+Error'
        let out[idx] = out[idx]. ' ==== ' . line[4:] . " ===="
      endif
    endif
  endfor
  "echo a:lines
  return out
endfunction

function! qf#Ptest(regex, winnr, name_prefix_pattern_to_remove)
  if a:regex != ""
    let regex = a:regex
  else
    let name = bufname(winbufnr(a:winnr))
    "let regex = substitute(name, , "", "")
    if a:name_prefix_pattern_to_remove != ''
      let regex = substitute(name, a:name_prefix_pattern_to_remove, "", "")
    elseif exists('g:Ptest_name_prefix')
      let regex = substitute(name, g:Ptest_name_prefix, "", "")
    else
      let regex = name
    endif
  endif
  echo regex
  call job#new(['pptest', regex], {
        \ 'onexit':'copen',
        \ 'efm': g:efm_python_pptest,
        \ 'filter': function('qf#CleanPythonDoctestResult'),
        \ })
endfunction
