
if exists('g:loaded_run_python') && g:loaded_run_python == 1
    finish
endif

function! runpython#get_args(args)  abort
    let nargs = len(a:args)
    if nargs == 0
        return expand('%:p')
    endif
    let n = line("$")
    for i in range(1, n)
        let line = getline(i)
        let pattern = '^#\s\+#ARGS\s\+\(' . a:args . '\):\(.*\):\s*\(.*\)\n*'
        if line =~ pattern
            let command = substitute(substitute(line, pattern, '\3', ""), '^%',  expand('%:p'), '')
            let option = substitute(line, pattern, '\2', "")
            let j = i
            while command =~ '\s\+\\$' && j+1 <= n
                let nextline = substitute(getline(j+1), '^\(\s*#\s\+\)\?', '', '')
                let command = substitute(command, '\s\+\\$', ' ', '') . nextline
                let j += 1
            endwhile
            echom command
            return [command, option]
        endif
    endfor
    return []
endfunction

function! runpython#t_command(args)
    let args = runpython#get_args(a:args)
    if len(args)
        let g:last_python_command=args[0]
        exec 'T ' . args[0]
    endif
endfunction

function! runpython#t_last()
    if exists('g:last_python_command')
        exec 'T' g:last_python_command
    endif
endfunction

let g:loaded_run_python = 1
