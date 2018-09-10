
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
command! -range=-1 -nargs=1 -bang JobL :call job#spawn(scripting#parse(s:opts('lopen', <bang>1, <count>, <line1>, <line2>), <q-args>))
command! -range=-1 -nargs=1 -bang JobQ :call job#spawn(scripting#parse(s:opts('copen', <bang>1, <count>, <line1>, <line2>), <q-args>))
command! -range=-1 -nargs=1 -bang Job  :call job#spawn(scripting#parse(s:opts('echo' , <bang>1, <count>, <line1>, <line2>), <q-args>))

command! -nargs=? JobKill :call job#kill()

