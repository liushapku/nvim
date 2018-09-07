
" qf#SetQF(lines[, option_dic])
" option_dic: key:
"   nojump: do not jump, default 0
function! qf#SetQF(opts) abort
  let opts     = a:opts
  if has_key(opts, 'data')
    let data = opts['data']
  elseif has_key(opts, 'reg')
    let data = getreg(opts.reg, 1, 1)
  else
    echoerr 'no data or register provided'
    return
  endif
  let jump     = get(opts, 'jump', 0)
  let position = get(opts, 'action', 'copen')
  let reverse  = get(opts, 'reverse', 0)
  let oldefm   = &efm
  let &efm     = get(opts, 'efm', &efm)

  let workspacepat = substitute($WORKSPACE, 'workspace[0-9]', 'workspace[0-9]', '')
  let workspacetarget = $WORKSPACE
  let qflist = filter(data, 'v:val != ""')
  let qflist = map(qflist, 'substitute(v:val, "^/site/home", "/home", "")')
  let qflist = map(qflist, 'substitute(v:val, workspacepat, workspacetarget, "")')
  if reverse
    let qflist = reverse(qflist)
  endif
  try
    if position == 'lopen'
      lgetexpr qflist
      belowright lopen
      if jump | cc | endif
    else
      cgetexpr qflist
      botright copen
      if jump | ll | endif
    endif
  finally
    let &efm = oldefm
  endtry
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

function! s:CleanPythonDoctestResult(lines) abort
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
  echo 'pptest' regex
  call job#new(['pptest', regex], {
        \ 'onexit':'copen',
        \ 'efm': g:efm_python_pptest,
        \ 'transform': function('s:CleanPythonDoctestResult'),
        \ })
endfunction
