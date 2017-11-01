" run resource/message.py to open listener
let g:echo_to_listener = 1
let g:my_message_url = 'localhost:2005/vim'
function! SendMessage(str)
  let resp = webapi#http#post(g:my_message_url, {'msg': a:str})
  if resp.status != '200'
    echomsg 'Echo ' . a:str . ' failed: ' . resp.message
  endif
endfunction

function! Echo(...) abort
  let message = a:0 == 1? string(a:000[0]) : ''
  if g:echo_to_listener
      call SendMessage(message)
  else
    echomsg message
  endif
endfunction

command! -nargs=? Echo call Echo(<args>)

