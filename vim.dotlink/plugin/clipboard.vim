"" BEGIN Clipboard ----------------------------
"function! Putclip(type, ...) range
    "let sel_save = &selection
    "let &selection = "inclusive"
    "let reg_save = @@
    "if a:type == 'n'
        "silent exe a:firstline . "," . a:lastline . "y"
    "elseif a:type == 'c'
        "silent exe a:1 . "," . a:2 . "y"
    "else
        "silent exe "normal! `<" . a:type . "`>y"
    "endif
    ""call system('putclip', @@)
    ""As of Cygwin 1.7.13, the /dev/clipboard device was added to provide
    ""access to the native Windows clipboard. It provides the added benefit
    ""of supporting utf-8 characters which putclip currently does not. Based
    ""on a tip from John Beckett, use the following:
    "call writefile(split(@@,"\n"), '/dev/clipboard')
    "let &selection = sel_save
    "let @@ = reg_save
"endfunction

"function! Getclip()
    "let reg_save = @@
    ""let @@ = system('getclip')
    ""Much like Putclip(), using the /dev/clipboard device to access to the
    ""native Windows clipboard for Cygwin 1.7.13 and above. It provides the
    ""added benefit of supporting utf-8 characters which getclip currently does
    ""not. Based again on a tip from John Beckett, use the following:
    "let @@ = join(readfile('/dev/clipboard'), "\n")
    "setlocal paste
    "exe 'normal p'
    "setlocal nopaste
    "let @@ = reg_save
"endfunction

"function! Cutclip(type, ...) range
    "let sel_save = &selection
    "let &selection = "inclusive"
    "let reg_save = @@
    "if a:type == 'n'
        "silent exe a:firstline . "," . a:lastline . "d"
    "elseif a:type == 'c'
        "silent exe a:1 . "," . a:2 . "d"
    "else
        "silent exe "normal! `<" . a:type . "`>d"
    "endif
    "call system('putclip', @@)
    "let &selection = sel_save
    "let @@ = reg_save
"endfunction

"nnoremap <silent> <leader>p :call Getclip()<CR>
"" use 3\y to copy 3 lines
"nnoremap <silent> <leader>y :call Putclip('n', 1)<CR>
"vnoremap <silent> <leader>y :call Putclip(visualmode(), 1)<CR>
"" use 3\d to cut 3 lines
"nnoremap <silent> <leader>d :call Cutclip('n', 1)<CR>
"vnoremap <silent> <leader>d :call Cutclip(visualmode(), 1)<CR>

" END Clipboard ----------------------------
"

