
function! autocmd#BufWinLeave()
  if &diff
    diffoff!
  endif
endfunction

function! autocmd#BufWinEnter()
  if &ft == 'csv' && b:delimiter == "\t"
    setlocal conceallevel=0
  else
    setlocal conceallevel=2
  endif
endfunction

function! autocmd#WinEnter()
  "Echo "winenter"
  if &buftype == 'quickfix'
  stopinsert
  endif
endfunction

function! autocmd#BufEnter()
  "Echo  "bufenter"
  call buffer#AutoRestoreWinView()
  if &buftype == 'quickfix'
  endif

  if &buftype == 'help'
    nnoremap <buffer> q :<c-u>q<cr>
    stopinsert
  elseif &buftype == 'terminal'
    if expand('%') =~ 'neoterm-[0-9]\+$'
      let g:current_neoterm = substitute(expand('%'), '.*neoterm-\([0-9]\)\+$', '\1', 0)
      set ft=neoterm
    endif
  elseif &buftype == 'quickfix' && exists("w:quickfix_title") && w:quickfix_title =~ 'git.*log'
    nnoremap <buffer> v <c-w><cr><C-w>L
    nnoremap <buffer> s <c-w><cr><C-w>K
    nmap <buffer> dv <cr>:only <bar> Gvdiff<cr>:botright copen<cr>
    nmap <buffer> ds <cr>:only <bar> Gsdiff<cr>:botright copen<cr>
  endif

  if bufname('%') =~ '\.git/COMMIT_EDITMSG' || bufname('%') =~ 'ipython_edit.*py'
    setlocal bufhidden=delete
  endif
endfunction

function! autocmd#BufLeave()
  call buffer#AutoSaveWinView()
  "if index(['python'], &filetype) > -1
  " silent! write
  "endif
endfunction

function! autocmd#WinLeave()
endfunction

function! autocmd#FileOpen()
  if bufname('%') =~ 'JP.*\.20[0-9]\{6\}'
    echo bufname('%')
    setfiletype csv
  endif
endfunction
