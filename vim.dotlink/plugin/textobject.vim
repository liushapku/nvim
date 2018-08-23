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

function! s:DelimiterBlock(prefix, delimiter_pattern, delimiter)
  let c = col('.')-1
  if getline('.')[c] !~ '\('. a:delimiter_pattern . '\)' && c!=0
    call search('\(^\|' . a:delimiter_pattern . '\|\W\)', 'b')
    if getline('.')[col('.')-1] =~ '\(' . a:delimiter_pattern . '\|\W\)'
      normal l
    endif
  elseif c != 0
    normal l
  endif
  normal v
  let pattern = '\(' . a:delimiter_pattern . '\|\W\|$\)'
  echo col('.') pattern a:delimiter_pattern
  call search('\(' . a:delimiter_pattern . '\|\W\|$\)', 'e')
  echo col('.')
  if  a:prefix == 'i'
    normal h
  elseif getline('.')[col('.')-1] != a:delimiter  " the end delimiter is not '.'
    exe ('normal hvvF' . a:delimiter)
  endif
endfunction

" do not know why inside the function a:delimiter_pattern == '\.\|_'
" if pass '\.\|_' then a:delimiter_pattern == '\.|_'
vmap i_ :<c-u>call <SID>DelimiterBlock('i', '\.\\|_', '_')<cr>
vmap a_ :<c-u>call <SID>DelimiterBlock('a', '\.\\|_', '_')<cr>
omap i_ :normal vi_<cr>
omap a_ :normal va_<cr>

vmap i. :<c-u>call <SID>DelimiterBlock('i', '\.', '.')<cr>
vmap a. :<c-u>call <SID>DelimiterBlock('a', '\.', '.')<cr>
omap i. :normal vi.<cr>
omap a. :normal va.<cr>
