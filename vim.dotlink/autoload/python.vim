
function! python#NumIncrease(count)
    let l:cword = expand('<cword>')
    echo l:cword
    if a:count == 0
        return
    endif
    if l:cword ==# "True"
        exec "s/True/False"
        noh
    elseif l:cword ==# 'False'
        exec "s/False/True"
        noh
    elseif a:count > 0
        exec "normal! " . a:count . "\<C-A>"
    elseif a:count < 0
        exec "normal! " . (-a:count) . "\<C-X>"
    endif
endfunction

function! python#CallAutoPep8(type)
    '[,']call Autopep8(type)
endfunction

function! python#Import(...) abort
    if a:0
        normal m'
        call cursor(line('$'), 1)
        let lineno =  search('^import', 'b')
        call append(lineno, 'import ' . join(a:000))
    else
        s/from\s\+\(\S\+\)\s\+import\s\+\(.*\)$/import \1/
    endif
endfunction

function! python#ImportFrom(...) abort
    if a:0 >= 2
        normal m'
        call cursor(line('$'), 1)
        let lineno =  search('^import', 'b')
        call append(lineno, 'from ' . a:1 . ' import ' . join(a:000[1:]))
    elseif a:0 == 1
        exe 's/import\s\+\(\S\+\)\s*$/from \1 import ' . a:1
    endif
endfunction
