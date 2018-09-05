function! operators#SelectArea(motionwise)
    if a:motionwise == 'char'
        normal `[v`]
    elseif a:motionwise == 'line'
        normal `[V`]
    else
        normal `[`]
    endif
endfunction

function! operators#ClearText(motionwise)
    call operators#SelectArea(a:motionwise)
    exe "normal r "
endfunction
