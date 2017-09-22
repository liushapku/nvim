"nnoremap <buffer> q :<c-u>q<cr>
tnoremap <buffer> <esc>q <c-\><c-n>:q<cr>
nnoremap <buffer> <c-]><c-]> :<c-u>call buffer#GoToNeoterm(v:count)<cr>a
nnoremap <buffer> <c-]><c-[> :<c-u>call buffer#GoToNeoterm(v:count, 1)<cr>a


command! -buf -nargs=* Insert call TermInsert(<q-args>)
tnoremap <buffer> <C-R><C-P> <C-\><C-n>:call terminal#TermInsert(getcwd())<cr>
" directly set @* doesn't work, don't know reason
tnoremap <buffer> <C-Y> <c-\><c-n>:let @a=terminal#CopyLastCommand()<cr>:let @*=@a<cr>
tnoremap <buffer> <MiddleMouse> <MiddleMouse>a

setlocal isk&vim
setlocal isk+=.,+,-
