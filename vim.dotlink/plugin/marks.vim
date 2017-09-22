" 暫存／復原 position    {{{2

  " @params stash/pop
  function! PosStash(...)
    let l:stash = a:0 > 0 ? a:1 : 0
    if l:stash
      let s:stashCursor = getpos(".")
      let g:stashCursor = s:stashCursor
    else
      call setpos('.', s:stashCursor)
    endif
  endf

" }}}2   暫存／復原 register 內容   {{{2

  " @params stash/pop, regname
  function! RegStash(...)
    let l:stash = a:0 > 0 ? a:1 : 0
    let l:regname = a:0 > 1 ? a:2 : v:register
    if l:stash
      let s:stashReg = [getreg(l:regname), getregtype(l:regname)]
      let g:stashReg = s:stashReg
    else
      call setreg(l:regname, s:stashReg[0], s:stashReg[1])
    endif
  endf

" }}}2   暫存／復原 mark 內容   {{{2

  " @params stash/pop, markname
  function! MarkStash(...)
    let l:stash = a:0 > 0 ? a:1 : 0
    let l:markname = a:0 > 1 ? a:2 : 'm'
    if l:stash
      let s:stashMark = getpos("'" . l:markname)
      let g:stashMark = s:stashMark
      call setpos("'" . l:markname, getpos('.'))
    else
      call setpos("'" . l:markname, s:stashMark)
    endif
  endf

" }}}2
