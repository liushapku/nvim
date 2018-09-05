function! MyGoto(...)
    if a:0 == 0
        normal G
        call search('^import', 'b')
        normal zz
    else
        call search('\c\(def\|class\) ' . a:1, 'c')
        normal zt
    endif
endfunction
command! -nargs=? TO call MyGoto(<f-args>)
