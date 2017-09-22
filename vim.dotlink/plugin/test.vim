

nmap <silent> <expr> <F4> ':<c-u>set opfunc=CountSpaces<CR>' . v:count . '"' . v:register . 'g@'
"vmap <silent> <F4> :<C-U>call CountSpaces(visualmode())<CR>
vmap <silent> <F4> :<c-u>set opfunc=CountSpaces<CR>gvg@

function! CountSpaces(type)
  let sel_save = &selection
  let &selection = "inclusive"
  let reg_save = @@

  echo a:type v:count v:register getpos("'[") getpos("']")
  if a:type == 'line'
    silent exe "normal! '[V']y"
  elseif a:type == 'char'
    silent exe "normal! `[v`]y"
  else  " Invoked from Visual block mode, use gv command.
    silent exe "normal! `[\<C-V>`]y"
  endif

  "echomsg a:type strlen(substitute(@@, '[^ ]', '', 'g'))

  let &selection = sel_save
  let @@ = reg_save
endfunction

