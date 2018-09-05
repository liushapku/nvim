let g:terminal_scrollback_buffer_size=100000

function! JobStart(cmd, Callback, extra)
    let Fun = a:Callback
    let callbacks = {
            \ 'on_stdout': Fun,
            \ 'on_stderr': Fun,
            \ 'on_exit': Fun
            \ }
    let instance = extend(callbacks, a:extra)
    let instance.id = jobstart(['bash', '-c', a:cmd], extend(callbacks, a:extra))
    return instance
endfunction

function! DefaultJobCallback(jobid, data, event)
    if a:event == 'stdout'
        let @o=join(a:data)
    elseif a:event == 'stderr'
        let @e=join(a:data)
    elseif a:event == 'exit'
        let @x=a:data
    endif
endfunction

function! TermStart(cmds, Callback, extra, options)
    let Fun = a:Callback
    let callbacks = {
            \ 'on_stdout': Fun,
            \ 'on_stderr': Fun,
            \ 'on_exit': Fun
            \ }
    let instance = extend(callbacks, a:extra)
    let mod = get(a:options, 'splitmod', '')
    exec mod . ' split'
    enew
    let instance.id = termopen(a:cmds, extend(callbacks, a:extra))
    let instance.bufnr= bufnr('%')
    return instance
endfunction


