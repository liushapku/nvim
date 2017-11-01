" run resource/message.py to open listener
let g:echo_channel = 'none'
let g:my_message_url = 'localhost:2005/vim'
function! SendMessage(str, type)
  let resp = webapi#http#post(g:my_message_url, {'msg': a:str, 'type': a:type})
  if resp.status != '200'
    echomsg 'Echo ' . a:str . ' failed: ' . resp.message
  endif
endfunction

function! Echo(type, ...)
  let message = a:0 == 1? string(a:000[0]) : ''
  if g:echo_channel == 'server'
    call SendMessage(message, a:type)
  elseif g:echo_channel == 'echo'
    if a:type == 'error'
      echoerr message
    else
      echomsg message
    endif
  endif
endfunction

command! -bang -nargs=? Echo call Echo(<bang>0? 'error': 'info', <args>)

