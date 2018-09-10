augroup BufAu
  autocmd!
  autocmd BufEnter * call autocmd#BufEnter()
  autocmd BufLeave * call autocmd#BufLeave()
  autocmd BufWinLeave * call autocmd#BufWinLeave()
  autocmd BufWinEnter * call autocmd#BufWinEnter()

  autocmd BufWinEnter term://* normal i
  autocmd BufWinLeave term://* stopinsert

  " quickfix window  s/v to open in split window,  ,gd/,jd => quickfix window => open it
augroup END

"augroup TestAu
"  autocmd!
"  autocmd BufWritePost * echomsg "write done"
"augroup END

augroup FileTypeAu
  autocmd!
  autocmd FileType markdown,html,json nmap <buffer> <F5> :<c-u>AsyncRun google-chrome <c-r>=expand('%:p')<cr><cr>
  autocmd FileType vim,markdown TabSet 2
  autocmd FileType help set buftype=help
  autocmd FileType help,man set bufhidden=delete
augroup END
" with !, set globally
command! -nargs=1 -bang TabSet call s:tab_set(<bang>1, <args>)
function! s:tab_set(local, n)
  let set = a:local? 'setlocal': 'set'
  exe printf('%s expandtab tabstop=%d softtabstop=%d shiftwidth=%d', set, a:n, a:n, a:n)
endfunction

augroup TermAu
  autocmd!
  au TermOpen * startinsert
  au TermOpen * nnoremap <buffer> <c-c> a<c-c>
augroup END

augroup WinAu
  autocmd!
  autocmd WinEnter * call autocmd#WinEnter()
  "autocmd WinEnter term://* normal i
  autocmd WinLeave * call autocmd#WinLeave()
  "autocmd WinLeave term://* stopinsert
augroup END

augroup FileAu
  autocmd!
  autocmd BufNewFile,BufReadPost *.ipynb setfiletype=json
  autocmd BufNewFile,BufReadPost * call autocmd#FileOpen()
  autocmd BufNewFile,BufReadPost * call autocmd#FugitiveAddCustomCommands()
augroup END

augroup QuickFixCmdPostAu
  autocmd!
  autocmd QuickFixCmdPost [^l]* call autocmd#QuickFixPostAuFunc('c')
  autocmd QuickFixCmdPost l*   call autocmd#QuickFixPostAuFunc('l')
  "autocmd QuickFixCmdPost *git* echomsg 'git'
  "autocmd QuickFixCmdPost git botright cwindow | call s:SetQFMapsForGlog()
  "autocmd QuickFixCmdPost  botright lwindow | call s:SetQFMapsForGlog()
augroup END

augroup TabAu
  autocmd!
  "autocmd TabNew * Startify
augroup END

function! s:fix_whitespace()
  if !has_key(b:, 'auto_fix_whitespace')
    if index(g:extra_whitespace_ignored_filetypes, &ft) < 0 && @% !~# (expand("$HOME") . '/\(mini\)\?conda')
      FixWhitespace
    endif
  elseif get(b:, 'auto_fix_whitespace')
    FixWhitespace
  endif
endfunction
augroup BufWriteAu
  autocmd!
  autocmd BufWritePre * call s:fix_whitespace()
augroup END
command! DisableAutoFixWhitespace let b:auto_fix_whitespace=0
command! EnableAutoFixWhitespace let b:auto_fix_whitespace=1
command! DefaultAutoFixWhitespace unlet b:auto_fix_whitespace

augroup VimAu
  autocmd!
  "autocmd VimEnter * !touch /tmp/vimenter
  "autocmd VimLeave * !touch /tmp/vimleave
augroup END

augroup VimLeavePreAu
  autocmd!
  autocmd VimLeavePre * :tabdo cclose
augroup END
