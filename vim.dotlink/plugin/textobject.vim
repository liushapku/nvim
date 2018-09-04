"======indentwise
let g:filetype_has_end_block_boundary = ['cpp', 'vim']
function! Has_end_block_boundary()
  return (index(g:filetype_has_end_block_boundary, &filetype) != -1)
endfunction

function! s:IndentBlock(prefix)
  if a:prefix == 'a'
    if (Has_end_block_boundary())
    normal [&[-Vj]&j
    else
    normal [&[-Vj]&
    endif
  else
    normal [&V]&
  endif
endfunction
map [& <Plug>(IndentWiseBlockScopeBoundaryBegin)
map ]& <Plug>(IndentWiseBlockScopeBoundaryEnd)
vmap ii :<c-u>call <SID>IndentBlock('i')<cr>
vmap ai :<c-u>call <SID>IndentBlock('a')<cr>
omap ii :normal Vii<cr>
omap ai :normal Vai<cr>

function! s:LocateBlock(string, col, delimiters, inside)
  let n = a:col - 1
  let firstmatch = index(a:delimiters, a:string[n]) != -1
  let beginmatch = 0
  for begin in range(n, 0, -1)
    if index(a:delimiters, a:string[begin]) != -1
      let beginmatch = 1
      break
    elseif (a:string[begin] !~ '\w')
      break
    endif
  endfor

  let endmatch = 0
  for end in range(n+1, len(a:string)-1)
    if index(a:delimiters, a:string[end]) != -1
      let endmatch = 1
      break
    elseif (a:string[end] !~ '\w')
      break
    endif
  endfor
  " change to col (1 based index0
  let begin += 1
  let end += 1

  "echo beginmatch endmatch begin end
  if a:inside
    return [begin+1, end-1]
  elseif firstmatch
    return [begin, end-1]
  elseif endmatch
    return [begin+1, end]
  elseif beginmatch
    return [begin, end-1]
  else
    return [begin+1, end-1]
  endif
endfunction

function! s:Select(delimiters, inside)
  let string = getline('.')
  let n = col('.')
  let [a, b ] = s:LocateBlock(string, n, a:delimiters, a:inside)
  "echo a b
  let cmd = a . '|v' .  b . '|'
  exe 'normal ' . cmd
endfunction

vmap i_ :<c-u>call <SID>Select(['.', '_'], 1)<cr>
vmap a_ :<c-u>call <SID>Select(['.', '_'], 0)<cr>
omap i_ :normal vi_<cr>
omap a_ :normal va_<cr>

vmap i. :<c-u>call <SID>Select(['.'], 1)<cr>
vmap a. :<c-u>call <SID>Select(['.'], 0)<cr>
omap i. :normal vi.<cr>
omap a. :normal va.<cr>

" cline to next line shorter (exclusive)
" cline to prev line shorter (exclusive)
" cline to next line longer (exclusive)
" cline to prev line longer (exclusive)
" prev line shorter to next line shorter (exclusive)
" prev line longer to next line longer (exclusive)
" prev line having a different length to the next line having a different length (exclusive)
call textobject#define_all([
      \ [";s", '<SID>FindLineLen("<", 0)'],
      \ [";S", '<SID>FindLineLen("<", 1)'],
      \ [";l", '<SID>FindLineLen(">", 0)'],
      \ [";L", '<SID>FindLineLen(">", 1)'],
      \ ["il", '<SID>ChangeMode("[nv]", "V").<SID>FindLineLen("<", 1)."o".<SID>FindLineLen("<", 0)'],
      \ ["iL", '<SID>ChangeMode("[nv]", "V").<SID>FindLineLen(">", 1)."o".<SID>FindLineLen(">", 0)'],
      \ ["i=", '<SID>ChangeMode("[nv]", "V").<SID>FindLineLen("=", 1)."o".<SID>FindLineLen("=", 0)'],
      \ ])

