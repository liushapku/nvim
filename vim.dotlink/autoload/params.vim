
function! s:auto_select()
  if exists('g:params#auto_select') && g:params#auto_select
    normal 
  endif
endfunction

function! params#Echo()
  for doc in b:echodoc
    if has_key(doc, 'highlight')
    execute 'echohl' doc.highlight
    echon doc.text
    echohl None
    else
    echon doc.text
    endif
  endfor
endfunction

function! params#GetParams()
  if !exists('b:echodoc')
    return ''
  endif

  let params = []
  let ident = ''
  let started = 0
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
      call add(params, doc.text)
    endif
  endfor
  return [ident, params]
endfunction

function! params#Complete(jump) abort
  if !exists('b:echodoc')
  return ''
  else
  let [ident, params] = params#GetParams()
  return join(params, ', ') . (a:jump? "\<esc>%":"")
  endif
endfunction

function! params#SelectNext()
  silent normal! vi,
  call s:auto_select()
endfunction

function! params#GotoNextPara() abort
  if search('[(,]', 'c')
    call search('\S', '')
  endif
endfunction
function! params#GotoPrevPara() abort
  if search('[,)]', 'bc')
    call search('[(,]\s*\S', 'be')
  endif
endfunction

function! params#SelectNextPara() abort
  if getline('.')[col('.')-1:] !~ '^[(,]'
    if !search('[(,]', '', line('.')) | return | endif
  endif
  call search('\S')
  silent normal vi,
  call s:auto_select()
endfunction

function! params#SelectNextEqual() abort
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
endfunction

function! params#SelectPrevPara() abort
  if getline('.')[col('.')-1:] !~ '^[),]'
    silent normal! ?[),]
  endif
  silent normal ?[(,]?;/\S/
  normal! v/[,)]/eh
  call s:auto_select()
endfunction

function! params#SelectPrevEqual() abort
  if getline('.')[col('.')-1:] !~ '^[),]'
    silent normal! ?,?
  endif
  silent normal! ?[=,]?
  call SelectNextEqual()
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
  for i in range(pos, col('$'))
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
