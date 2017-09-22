function! vimlocation#command(command)
    let ret = split(Redir('verb comm ' . a:command), "\n")
    for x in range(1, len(ret) - 1)
        if ret[x] =~ '\<' . a:command . '\>\s\+'
            return substitute(ret[x+1], '\s*Last set from ', '', '')
        endif
    endfor
endfunction

function! vimlocation#map(type, command, ...)
    let ret = split(Redir('verb ' . a:type . 'map ' . a:command), "\n")
    if a:0 == 0 && len(ret) != 2
        echoerr 'more than one map matches'
    elseif len(ret) == 2
        return substitute(ret[1], '\s*Last set from ', '', '')
    else
        return substitute(ret[2*a:1 -1], '\s*Last set from ', '', '')
    endif
    return ''
endfunction

function! vimlocation#function(name)
    try
        let ret = split(Redir('verb function ' . a:name), "\n")
        echo ret
        return substitute(ret[1], '\s*Last set from ', '', '')
    catch
        "echoerr 'function not found'
        return ''
    endtry
endfunction


function! vimlocation#edit_command(mods, pedit, command)
    let file = vimlocation#command(a:command)
    if file == ''
        return
    endif
    if a:pedit
        exe a:mods 'pedit' file
        wincmd P
    else
        exe a:mods 'new' file
    endif
    call search('^com.*\<'. a:command . '\>')
endfunction

function! vimlocation#edit_map(mods, pedit, type, command, ...)
    let file = call('vimlocation#map', [a:type, a:command] + a:000)
    if file == ''
        echo a:type a:command file
        return
    endif
    let command = a:command[0] == ';'? ('\(<leader>\|;\)' . a:command[1:]) : a:command
    let pattern = '^\c.*map .*' . command . ' '
    if a:pedit
        exe a:mods 'pedit' file
        wincmd P
    else
        exe a:mods 'new' file
    endif
    call search(pattern,  '')
endfunction

function! vimlocation#edit_function(mods, pedit, function)
    let file = vimlocation#function(a:function)
    if file == ''
        return
    endif
    if a:pedit
        exe a:mods 'pedit' file
        wincmd P
    else
        exe a:mods 'new' file
    endif
    call search('^function!\?\s\+\<'. a:function . '\>')
endfunction

