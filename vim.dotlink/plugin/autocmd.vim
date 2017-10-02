let g:term_auto_insert = 1

augroup BufAu
    autocmd!
    autocmd TermOpen * echo 'termopen' | call autocmd#TermOpen()
    autocmd BufEnter * call autocmd#BufEnter()
    "autocmd BufEnter * :echo <afile>
    autocmd BufLeave * call autocmd#BufLeave()
    autocmd BufWinLeave * call autocmd#BufWinLeave()
    autocmd BufWinEnter * call autocmd#BufWinEnter()
    autocmd BufDelete *#neoterm-* call autocmd#TBufDelete()
augroup END

augroup FileTypeAu
    autocmd!
    autocmd FileType qf call AdjustWindowHeight(3, 10)
    autocmd FileType markdown,html nmap <buffer> <F5> :<c-u>AsyncRun google-chrome <c-r>=expand('%:p')<cr><cr>
augroup END

augroup WinAu
    autocmd!
    autocmd WinEnter * call autocmd#WinEnter()
    autocmd WinEnter term://*neoterm* startinsert
    autocmd WinLeave * call autocmd#WinLeave()
    autocmd WinLeave term://*neoterm* stopinsert
augroup END

augroup FileAu
    autocmd!
    autocmd BufNewFile,BufRead * call autocmd#FileOpen()
augroup END


augroup QuickFixCmdPostAu
    autocmd!
    autocmd QuickFixCmdPost [^l]* botright cwindow
    autocmd QuickFixCmdPost l* botright lwindow
    autocmd QuickFixCmdPost Glog botright cwindow
    autocmd QuickFixCmdPost Gllog botright lwindow
augroup END
function! AdjustWindowHeight(minheight, maxheight)
  exe max([min([line("$"), a:maxheight]), a:minheight]) . "wincmd _"
endfunction


