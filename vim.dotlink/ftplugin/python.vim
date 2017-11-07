"set errorformat='%A%\s%#File "%f"\, line %l\, in%.%#,%+CFailed example:%.%#,%Z%*\s   %m,%-G*%\{70%\},%-G%*\d items had failures:,%-G%*\s%*\d of%*\s%*\d in%.%#'


"echom 'Enter: '. expand('%:p')
"
let b:deoplete_tab_called = 0
function! s:TabWrap() abort
    let prefix = strpart( getline('.'), 0, col('.') - 1 )
    if pumvisible()
        echo 'TabWrap: pumvisible'
        return "\<C-N>"
    elseif prefix == '' || prefix =~ '\s\+$'
        echo 'TabWrap: empty string'
        return "\<tab>"
    elseif b:deoplete_tab_called == 1 && &filetype == 'python'
        echo 'TabWrap: jedi'
        let b:deoplete_tab_called = 0
        return jedi#complete_string(0)
    elseif exists('g:loaded_deoplete') && g:loaded_deoplete == 1 && b:deoplete_tab_called == 0 && &filetype != 'vim'
        echo 'TabWrap: deoplete'
        let b:deoplete_tab_called = 1
        let result=deoplete#mappings#manual_complete()
        return result
    elseif &omnifunc != ''
        echo 'TabWrap: omnifunc'
        return "\<C-X>\<C-O>"
    else
        echo 'TabWrap: nothing' b:deoplete_tab_called
        return "\<tab>"
    endif
endfunction

augroup PyTabWrap
    au!  InsertEnter,CursorMovedI,CompleteDone <buffer> let b:deoplete_tab_called = 0
augroup END
inoremap <buffer><silent><expr><tab> TabWrap()

map <buffer> <F5> <Plug>(IPyRun)
imap <buffer> ,, <end>,
imap <buffer> ,) <end>)

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

setlocal equalprg=autopep8\ -
nmap <buffer> g= :set operatorfunc=python#CallAutoPep8<CR>g@
nmap <buffer> g== :exe "call python#CallAutopep8('--range " . line('.') . ' '  . line('.') . "')"<CR>
vmap <buffer> g= :call python#CallAutopep8()<CR>
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
