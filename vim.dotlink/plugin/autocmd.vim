let g:term_auto_insert = 1

augroup BufAu
    autocmd! TermOpen * echo 'termopen' | call autocmd#TermOpen()
    autocmd! BufEnter * call autocmd#BufEnter()
    "autocmd BufEnter * :echo <afile>
    autocmd! BufLeave * call autocmd#BufLeave()
    autocmd! BufWinLeave * call autocmd#BufWinLeave()
    autocmd! BufWinEnter * call autocmd#BufWinEnter()
    autocmd! BufDelete *#neoterm-* call autocmd#TBufDelete()
augroup END

augroup FileTypeAu
augroup END

augroup WinAu
    autocmd! WinEnter * call autocmd#WinEnter()
    autocmd! WinEnter term://*neoterm* startinsert
    autocmd! WinLeave * call autocmd#WinLeave()
    autocmd! WinLeave term://*neoterm* stopinsert
augroup END

augroup FileAu
    autocmd! BufNewFile,BufRead * call autocmd#FileOpen()
augroup END
