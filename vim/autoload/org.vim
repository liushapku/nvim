"py3 << EOF
"myshowhide = ORGMODE.plugins[u"ShowHide"]
"EOF

function! org#Fold(line, count, reverse)
    let pos = getpos('.')
    if a:line != 0
        exe a:line
    endif
    "let cmd = printf('', a:reverse? 'True': 'False')
    "echo a:count
    for x in range(1, a:count == 0? 1:a:count)
        py3 ORGMODE.plugins[u"ShowHide"].toggle_folding(reverse=bool(vim.eval('a:reverse')))
    endfor
    call setpos('.', pos)
endfunction

function! s:MarkAndOpen()
    if s:mark >= 1
        exe 'mark' s:mark
    endif
    foldopen
    if s:mark < 9
        let s:mark += 1
    else
        let s:mark = -1
    endif
endfunction

function! org#FoldPattern2(pattern)
    let pos = getpos('.')
    mark 0
    g/^\* /normal zM
    g/^\* /foldopen
    let s:mark = 1
    let command = 'g/\*\* ' . a:pattern . '/call s:MarkAndOpen()'
    exe command
    call setpos('.', pos)
endfunction

function! org#Compare(winnr)
    echomsg a:winnr
    let nr = a:winnr == 0? winnr() - 1 : a:winnr
    let nr = nr == 0? winnr('$') : nr
    exe nr . "Windo let g:org_temp_var = substitute(getline(1), '# dir: ', '', '')"
    call append('.', '# compare: ' . g:org_temp_var)
    unlet g:org_temp_var

endfunction
