

command! -nargs=* JobLf :call job#spawn({'onexit':'lopen'}, <f-args>)
command! -nargs=* JobQf :call job#spawn({'onexit':'copen'}, <f-args>)
command! -nargs=* Job   :call job#spawn({'onexit':'echo' }, <f-args>)
