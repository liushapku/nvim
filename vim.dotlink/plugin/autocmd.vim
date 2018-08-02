let g:term_auto_insert = 1

augroup BufAu
  autocmd!
  autocmd TermOpen * echo 'termopen' | call autocmd#TermOpen()
  autocmd BufEnter * call autocmd#BufEnter()
  "autocmd BufEnter * :echo <afile>
  autocmd BufLeave * call autocmd#BufLeave()
  autocmd BufWinLeave * call autocmd#BufWinLeave()
  autocmd BufWinEnter * call autocmd#BufWinEnter()

  " quickfix window  s/v to open in split window,  ,gd/,jd => quickfix window => open it
augroup END

augroup FileTypeAu
  autocmd!
  autocmd FileType qf call AdjustWindowHeight(3, 10)
  autocmd FileType markdown,html,json nmap <buffer> <F5> :<c-u>AsyncRun google-chrome <c-r>=expand('%:p')<cr><cr>
  autocmd FileType vim,markdown TabSet 2
augroup END
command! -nargs=1 -bang TabSet call s:tab_set(<bang>0, <args>)
function! s:tab_set(bang, n)
  let set = a:bang? 'set': 'setlocal'
  exe printf('%s expandtab tabstop=%d softtabstop=%d shiftwidth=%d', set, a:n, a:n, a:n)
endfunction

augroup WinAu
  autocmd!
  autocmd WinEnter * call autocmd#WinEnter()
  autocmd WinEnter term://* normal i
  autocmd WinLeave * call autocmd#WinLeave()
  autocmd WinLeave term://* stopinsert
augroup END

augroup FileAu
  autocmd!
  autocmd BufNewFile,BufReadPost *.ipynb set filetype=json
  autocmd BufNewFile,BufReadPost * call autocmd#FileOpen()
  autocmd BufNewFile,BufReadPost * echomsg 'file open'
  autocmd BufNewFile,BufReadPost * call FugitiveAddCustomCommands()
augroup END
" fugitive
function! FugitiveAddCustomCommands()
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

  "command -nargs=+ GCommit Gcommit -m<q-args>
  "command -nargs=+ Gamend Gcommit --amend -m<q-args>
  "command -nargs=+ Gwc Gwrite <bar> Gcommit -m<q-args>
  "command -nargs=0 Gprev Gwrite <bar> Gcommit --amend --no-edit
  "command -nargs=* GDiff only | Gdiff <args>

augroup QuickFixCmdPostAu
  autocmd!
  autocmd QuickFixCmdPost [^l]* call QuickFixAuFunc('c')
  autocmd QuickFixCmdPost l*   call QuickFixAuFunc('l')
  "autocmd QuickFixCmdPost *git* echomsg 'git'
  "autocmd QuickFixCmdPost git botright cwindow | call s:SetQFMapsForGlog()
  "autocmd QuickFixCmdPost  botright lwindow | call s:SetQFMapsForGlog()
augroup END
function! QuickFixAuFunc(mode)
  "Echo 'quickfix'
  if a:mode == 'l'
    botright lwindow
  elseif a:mode == 'c'
    botright cwindow
  else
    return
  endif
endfunction

function! AdjustWindowHeight(minheight, maxheight)
  exe max([min([line("$"), a:maxheight]), a:minheight]) . "wincmd _"
endfunction


