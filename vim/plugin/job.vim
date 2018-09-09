

command! -nargs=1 -bang JobL :call job#spawn({'onexit':'lopen', '@list': <bang>1}, scripting#parse(0, <q-args>))
command! -nargs=1 -bang JobQ :call job#spawn({'onexit':'copen', '@list': <bang>1}, scripting#parse(0, <q-args>))
command! -nargs=1 -bang Job   :call job#spawn({'onexit':'echo', '@list': <bang>1}, scripting#parse(0, <q-args>))

command! -nargs=? JobKill :call job#kill()
