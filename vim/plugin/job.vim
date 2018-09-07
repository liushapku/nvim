

command! -nargs=* JobLf :call job#spawn({'onexit':'lopen'}, scripting#parse(0, <f-args>))
command! -nargs=* JobQf :call job#spawn({'onexit':'copen'}, scripting#parse(0, <f-args>))
command! -nargs=* Job   :call job#spawn({'onexit':'echo' }, scripting#parse(0, <f-args>))

command! -nargs=? JobKill :call job#kill()
