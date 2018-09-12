
function! s:opts(onexit, cmd_is_list, count, line1, line2)
  let rv =  {
        \ 'onexit': a:onexit,
        \ '@list' : a:cmd_is_list,
        \ '[AUTOPOSITIONAL]': 1,
        \ }
  if a:count != -1  "range provided
    let rv['@range'] = [a:line1, a:line2]
    let rv['eof'] = 1
  endif
  return rv
endfunction

command! -range=-1 -nargs=1 -bang -complete=customlist,scripting#complete
      \ JobL :call job#spawn(scripting#parse(s:opts('lgetexpr', <bang>1, <count>, <line1>, <line2>), <q-args>))
command! -range=-1 -nargs=1 -bang -complete=customlist,scripting#complete
      \ JobQ :call job#spawn(scripting#parse(s:opts('cgetexpr', <bang>1, <count>, <line1>, <line2>), <q-args>))
command! -range=-1 -nargs=1 -bang -complete=customlist,scripting#complete
      \ Job  :call job#spawn(scripting#parse(s:opts('echo' , <bang>1, <count>, <line1>, <line2>), <q-args>))

command! -nargs=? JobKill :call job#kill()


