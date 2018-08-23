
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

" fugitive
function! autocmd#FugitiveAddCustomCommands()
  let in_git = exists('b:git_dir') || fugitive#extract_git_dir(expand('%:p')) !=# ''
  let has_custom_commands = get(b:, 'fugitive_custom_commands', 0)
  if in_git && !has_custom_commands
    let b:fugitive_custom_commands = 1
    command -buffer -nargs=+ GCommit Gcommit -m<q-args>
    command -buffer -nargs=* GStatus Gstatus | wincmd K
    command -buffer -nargs=+ Gamend Gcommit --amend -m<q-args>
    command -buffer -nargs=+ Gwc Gwrite <bar> Gcommit -m<q-args>
    command -buffer -nargs=0 Gprev Gwrite <bar> Gcommit --amend --no-edit
    command -buffer -nargs=* GDiff only | Gdiff <args>
  endif
endfunction

function! autocmd#QuickFixAuFunc(mode)
  "Echo 'quickfix'
  if a:mode == 'l'
    botright lwindow
  elseif a:mode == 'c'
    botright cwindow
  else
    return
  endif
endfunction

function! autocmd#AdjustWindowHeight(minheight, maxheight)
  exe max([min([line("$"), a:maxheight]), a:minheight]) . "wincmd _"
endfunction
