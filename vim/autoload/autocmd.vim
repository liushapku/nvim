
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

  if &buftype == 'quickfix'
    call autocmd#AdjustWindowHeight(3, 10)
  endif
endfunction

function! s:CopyQuickfix() range
  let x = getline(a:firstline, a:lastline)
  let x = map(x, 'substitute(v:val, ''\([^|]*|\)\{2} '', "", "")')
  call setreg(v:register, x, "V")
endfunction
function! autocmd#WinEnter()
  "Echo "winenter"
  if &buftype == 'quickfix'
    stopinsert
    call autocmd#AdjustWindowHeight(3, 10)
  endif
endfunction


function! autocmd#BufEnter()
  "Echo  "bufenter"
  call buffer#restore_win_view()

  if &buftype == 'help'
    nnoremap <buffer> q :<c-u>q<cr>
    stopinsert
  elseif &buftype == 'terminal'
    if expand('%') =~ 'neoterm-[0-9]\+$'
      let g:current_neoterm = substitute(expand('%'), '.*neoterm-\([0-9]\)\+$', '\1', 0)
      set ft=neoterm
    endif
  elseif &buftype == 'quickfix'
    if exists("w:quickfix_title") && w:quickfix_title =~ 'git.*log'

      nnoremap <buffer> v <c-w><cr><C-w>L
      nnoremap <buffer> s <c-w><cr><C-w>K
      nmap <buffer> dv <cr>:only <bar> Gvdiff<cr>:botright copen<cr>
      nmap <buffer> ds <cr>:only <bar> Gsdiff<cr>:botright copen<cr>
    endif
  endif

  if bufname('%') =~ '\.git/COMMIT_EDITMSG' || bufname('%') =~ 'ipython_edit.*py'
    setlocal bufhidden=delete
  endif
endfunction

function! autocmd#BufLeave()
  call buffer#save_win_view()
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
function! s:Gg(arg, ...)
  let g:Ggrep_pattern = a:arg
endfunction
function! autocmd#FugitiveAddCustomCommands()
  let in_git = exists('b:git_dir') || fugitive#extract_git_dir(expand('%:p')) !=# ''
  if in_git && !get(b:, 'fugitive_custom_commands', 0)
    let b:fugitive_custom_commands = 1
    command -buffer -nargs=+ GCommit Gcommit -m<q-args>
    command -buffer GStatus Gstatus | wincmd K
    command -buffer Gs tab Gstatus
    command -buffer -nargs=+ Gamend Gcommit --amend -m<q-args>
    command -buffer -nargs=+ Gwc Gwrite <bar> Gcommit -m<q-args>
    command -buffer -nargs=0 Gprev Gwrite <bar> Gcommit --amend --no-edit
    command -buffer -nargs=* GDiff only | Gdiff <args>
    command -buffer -nargs=* Gd tabedit % | Gvdiff <args>
    command -buffer -nargs=+ Gg call s:Gg(<f-args>) | Ggrep <args>
  endif
endfunction

function! autocmd#QuickFixPostAuFunc(mode)
  "Echo 'quickfix'
  if &grepprg =~# '^git\>.*\<grep\>' && exists('g:Ggrep_pattern')
    let lst = getqflist()
    for i in range(len(lst))
      let item = lst[i]
      let item.col = match(item.text, g:Ggrep_pattern) + 1
      let lst[i] = item
    endfor
    unlet g:Ggrep_pattern
    call setqflist(lst, 'r')
  endif

  if a:mode == 'l'
    botright lwindow
  elseif a:mode == 'c'
    botright cwindow
  endif
endfunction

function! autocmd#AdjustWindowHeight(minheight, maxheight)
  exe max([min([line("$"), a:maxheight]), a:minheight]) . "wincmd _"
endfunction
