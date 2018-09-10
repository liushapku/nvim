
"nmap <buffer> <CR> :silent exec 'cc ' . line('.')<CR>
function! s:CopyQuickfix() range
  let x = getline(a:firstline, a:lastline)
  let x = map(x, 'substitute(v:val, ''\([^|]*|\)\{2} '', "", "")')
  call setreg(v:register, x, "V")
endfunction
nnoremap <buffer> <silent> yy :call <SID>CopyQuickfix()<cr>

nnoremap <buffer> q :<c-u>q<cr>

let b:qf_title = getqflist({'title':1})['title']
echomsg b:qf_title

if b:qf_title =~ '^:git.* log '
  nnoremap <buffer> v <c-w><cr><C-w>L
  nnoremap <buffer> s <c-w><cr><C-w>K
  nmap <buffer> dv <cr>:only <bar> Gvdiff<cr>:botright copen<cr>
  nmap <buffer> ds <cr>:only <bar> Gsdiff<cr>:botright copen<cr>
endif

stopinsert
