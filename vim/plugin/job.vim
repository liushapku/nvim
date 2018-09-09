
function! s:opts(onexit, cmd_is_list)
  return {'onexit': a:onexit,
        \ '@list' : a:cmd_is_list,
        \ '[AUTOPOSITIONAL]': 1,
        \ }
endfunction
command! -nargs=1 -bang JobL :call job#spawn(scripting#parse(s:opts('lopen', <bang>1), <q-args>))
command! -nargs=1 -bang JobQ :call job#spawn(scripting#parse(s:opts('copen', <bang>1), <q-args>))
command! -nargs=1 -bang Job  :call job#spawn(scripting#parse(s:opts('echo', <bang>1), <q-args>))

command! -nargs=? JobKill :call job#kill()
