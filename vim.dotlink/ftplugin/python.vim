"set errorformat='%A%\s%#File "%f"\, line %l\, in%.%#,%+CFailed example:%.%#,%Z%*\s   %m,%-G*%\{70%\},%-G%*\d items had failures:,%-G%*\s%*\d of%*\s%*\d in%.%#'


"echom 'Enter: '. expand('%:p')
"
let b:deoplete_tab_called = 0

command! -buffer Print3 s/print\s\+\(.*\)$/print(\1)/

" disabled nvim-ipy plugin
"call SetIPyMappiVngs()

imap <buffer> ,, <end>,
imap <buffer> ,) <end>)

nmap <buffer> ]} ]m
nmap <buffer> [{ [m

let &l:errorformat= g:python_traceback_format
setlocal smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class,#
setlocal completeopt-=preview
"let b:deoplete_disable_auto_complete = 1

map <buffer> <C-A> :<C-U>call python#NumIncrease(v:count1)<CR>
map <buffer> <C-X> :<C-U>call python#NumIncrease(-v:count1)<CR>

"command! -nargs=* -buffer RunPython call runpython#command(<q-args>, <q-mods>)
command! -nargs=* -buffer RunPython call runpython#t_command(<q-args>)
command! -buffer RunPythonLast call runpython#t_last()
command! -buffer Doctest AsyncRun python -m doctest %
vnoremap <buffer> ;ts "+y:silent call g:neoterm.instances[g:current_buf_term].do('%paste')<CR>

"setlocal equalprg=autopep8\ -
"nmap <buffer> g= :set operatorfunc=python#CallAutoPep8<CR>g@
"nmap <buffer> g== :exe "call python#CallAutopep8('--range " . line('.') . ' '  . line('.') . "')"<CR>
"vmap <buffer> g= :call python#CallAutopep8()<CR>
nnoremap <buffer> ( F(
nnoremap <buffer> ) f)
nnoremap <buffer> [( F(
nnoremap <buffer> ]( f(
nnoremap <buffer> [) F)
nnoremap <buffer> ]) f)


command! -buffer -nargs=* Import call python#Import(<f-args>)
command! -buffer -nargs=+ ImportFrom call python#ImportFrom(<f-args>)
command! -buffer -bar Hashbang :0put ='#!/usr/bin/env python' | w | Chmod a+x
let b:delimitMate_expand_cr = 1

nmap <buffer> <F5> :TREPLSendLine<cr><Down>
vmap <buffer> <F5> :TREPLSendLine<cr>'><Down>
map <buffer> <F17> :TREPLSendFile<cr>   " <S-F5>
"map <buffer> <F29> :TREPLSendLine<cr>   " <C-F5>
command! -buffer IPy RightE Tnew | TREPLSetTerm 0


