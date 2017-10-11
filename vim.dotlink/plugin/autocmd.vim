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
    autocmd FileType markdown,html,json nmap <buffer> <F5> :<c-u>AsyncRun google-chrome <c-r>=expand('%:p')<cr><cr>
    autocmd FileType vim,markdown setlocal tabstop=2 softtabstop=2 shiftwidth=2
augroup END
command! -nargs=1 TabSet setlocal tabstop=<args> softtabstop=<args> shiftwidth=<args>

augroup WinAu
    autocmd!
    autocmd WinEnter * call autocmd#WinEnter()
    autocmd WinEnter term://*neoterm* startinsert
    autocmd WinLeave * call autocmd#WinLeave()
    autocmd WinLeave term://*neoterm* stopinsert
augroup END

augroup FileAu
    autocmd!
    autocmd BufNewFile,BufReadPost *.ipynb set filetype=json
    autocmd BufNewFile,BufReadPost * call autocmd#FileOpen()
    autocmd BufNewFile,BufReadPost * call FugitiveAddCustomCommands()
    autocmd BufNewFile,BufReadPost */.git/index nmap OD :only <bar> normal dv<cr>
augroup END
" fugitive
function! FugitiveAddCustomCommands()
  let in_git = exists('b:git_dir') || fugitive#extract_git_dir(expand('%:p')) !=# ''
  let has_custom_commands = get(b:, 'fugitive_custom_commands', 0)
  if in_git && !has_custom_commands
    let b:fugitive_custom_commands = 1
    command -buffer -nargs=+ GCommit Gcommit -m<q-args>
    command -buffer -nargs=+ Gamend Gcommit --amend -m<q-args>
    command -buffer -nargs=+ Gwc Gwrite <bar> Gcommit -m<q-args>
    command -buffer -nargs=0 Gprev Gwrite <bar> Gcommit --amend --no-edit
    command -buffer -nargs=* GDiff only | Gdiff <args>
  endif
endfunction


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


