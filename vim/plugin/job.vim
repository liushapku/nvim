

command! -nargs=1 JobLf :call job#spawn({'onexit':'lopen'}, scripting#parse(0, <q-args>))
command! -nargs=1 JobQf :call job#spawn({'onexit':'copen'}, scripting#parse(0, <q-args>))
command! -nargs=1 Job   :call job#spawn({'onexit':'echo' }, scripting#parse(0, <q-args>))

command! -nargs=? JobKill :call job#kill()
