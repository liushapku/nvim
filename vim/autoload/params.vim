function! s:auto_select()
  if exists('g:params#auto_select') && g:params#auto_select
    normal 
  endif
endfunction

function! params#Echo()
  if empty(get(b:, 'echodoc', []))
    return ''
  endif
  echo ''
  for doc in b:echodoc
    if has_key(doc, 'highlight')
      execute 'echohl' doc.highlight
      echon doc.text
      echohl None
    else
    echon doc.text
    endif
  endfor
  return ''
endfunction

function! params#GetParams()
  if !exists('b:echodoc')
    return ''
  endif

  let params = []
  let ident = ''
  let started = 0
  let idx = 0
  for doc in b:echodoc
    if get(doc, 'highlight', '') == 'Identifier'
      let ident = doc.text
      continue
    endif
    if doc.text is '('
      let started = 1
      continue
    elseif doc.text is ')'
      let started = 0
      continue
    elseif doc.text is ', '
      continue
    elseif started
      if get(doc, 'highlight', '') == 'Special'
        let idx = len(params)
      endif
      call add(params, doc.text)
    endif
  endfor
  return [ident, params, idx]
endfunction

function! params#Complete() abort
  if !exists('b:echodoc')
    return ''
  else
  let [ident, params, idx] = params#GetParams()
    return join(params[idx:], ', ') . (getline('.')[col('.')-1]==')'?'':'?')
  endif
endfunction

function! params#GotoNextPara(times) abort
  for i in range(a:times)
    call search('[(,]\s*\zs\S')
  endfor
endfunction
function! params#GotoPrevPara(times) abort
  for i in range(a:times)
    "call search('[),]', 'bc')
    call search('[(,]\s*\zs\S', 'b')
  endfor
endfunction

function! params#SelectNextPara(times) abort
  call params#GotoNextPara(a:times)
  normal vi,
  call s:auto_select()
endfunction
function! params#SelectPrevPara(times) abort
  call params#GotoPrevPara(a:times)
  normal vi,
  call s:auto_select()
endfunction


function! params#SelectNextEqual(times) abort
  "call search('[=),]'))
  "call params#GotoNextPara(a:times)
  "call search('[=),]')
  for i in range(a:times)
    if getline('.')[col('.')-1] != '='
      call search('[=),]')
    endif
    let nextchar = getline('.')[col('.')-1]
    if nextchar == ',' || nextchar == ')'
      startinsert
    else
      silent normal! l
      if getline('.')[col('.')-1] == ','
        startinsert
      else
        normal v],h
        call s:auto_select()
      endif
    endif
  endfor
endfunction

function! params#SelectPrevEqual(times) abort
  for i in range(a:times)
    if getline('.')[col('.')-1:] !~ '^[),]'
      silent normal! ?,?
    endif
    silent normal! ?[=,]?
    call SelectNextEqual()
  endfor
endfunction

function! params#GotoFunction(times) abort
  let line = getline('.')
  let pos = col('.') - 1
  let stack = a:times
  for i in range(pos, 0, -1)
    if line[i] == ')' && i!=pos
      let stack += 1
    elseif line[i] == '('
      let stack -= 1
    endif
    if stack == 0
      exe 'normal ' . (i+1) . '|'
      " go to end of word
      normal h
      return
    endif
  endfor
endfunction

function! params#GotoFunctionEnd(times) abort
  let line = getline('.')
  let pos = col('.') - 1
  let stack = a:times
  for i in range(pos, col('$')-1)
    if line[i] == '(' && i!=pos
      let stack += 1
    elseif line[i] == ')'
      let stack -= 1
    endif
    if stack == 0
      exe 'normal ' . (i+1) . '|'
      normal l
      return
    endif
  endfor
endfunction

function! params#Surround(motion_wiseness) abort
  let x = nr2char(getchar())
  let a = split("<([{", '\zs')
  let b = split(">)]}", '\zs')
  let i = index(b, x)
  if i != -1
    let x = a[i]
    let y = b[i]
  else
    let i = index(a, x)
    if i != -1
      let x = a[i]
      let y = b[i]
    else
      let y = x
    endif
  endif
  let [startline, startcol] = getpos("'[")[1:2]
  let [endline, endcol] = getpos("']")[1:2]
  if startline != endline
    return
  endif

  let string = getline('.')
  let new = string[:startcol-2] . x . string[startcol-1:endcol-1] . y . string[endcol:]
  call setline('.', new)
  call setpos("'[", [0, startline, startcol, 0])
  call setpos("']", [0, startline, endcol+2, 0])
  normal `]
endfunction

