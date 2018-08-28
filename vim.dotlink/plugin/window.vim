inoremap <A-h> <C-O><C-W>h
inoremap <A-j> <C-O><C-W>j
inoremap <A-k> <C-O><C-W>k
inoremap <A-l> <C-O><C-W>l
inoremap <A-n> <C-O><C-W>w
inoremap <A-p> <C-O><C-W>W
nnoremap <A-h> <C-W>h
nnoremap <A-j> <C-W>j
nnoremap <A-k> <C-W>k
nnoremap <A-l> <C-W>l
nnoremap <A-n> <C-W>w
nnoremap <A-p> <C-W>W
tnoremap <A-h> <C-\><C-n><C-W>h
tnoremap <A-j> <C-\><C-n><C-W>j
tnoremap <A-k> <C-\><C-n><C-W>k
tnoremap <A-l> <C-\><C-n><C-W>l
tnoremap <A-n> <C-\><C-n><C-W>w
tnoremap <A-p> <C-\><C-n><C-W>W

inoremap <a-pageup> <esc>gT
inoremap <a-pagedown> <esc>gt
nnoremap <a-pageup> gT
nnoremap <a-pagedown> gt
tnoremap <a-pageup> <c-\><c-n>gT
tnoremap <a-pagedown> <c-\><c-n>gt
imap <a-=> <a-pagedown>
imap <a--> <a-pageup>
nmap <a-=> <a-pagedown>
nmap <a--> <a-pageup>
tmap <a-=> <a-pagedown>
tmap <a--> <a-pageup>

tnoremap <Esc><ESC> <C-\><C-n>
tnoremap <esc>gw <c-\><c-n>
tnoremap <silent> <expr> <esc>gw v:count==0?"\<c-\>\<c-n>\<C-W>p":("\<c-\>\<c-n>". v:count . "\<C-W>\<C-W>")


" Close: holding the width or height of the window to the left or below
" Close!: hold the right or above
" the standard behavior of :close is to hold right and above
command! -bang -range -addr=windows Close call window#CloseHoldPrevious(<line1>, <bang>0)
command! -bang -range -addr=windows CloseHoldLeft call window#CloseHoldPrevious(<line1>, <bang>0)
command! -bang -range -addr=windows CloseHoldAbove call window#CloseHoldPrevious(<line1>, <bang>0)
command! -bang -range -addr=windows CloseHoldRight call window#CloseHoldPrevious(<line1>, <bang>1)
command! -bang -range -addr=windows CloseHoldBelow call window#CloseHoldPrevious(<line1>, <bang>1)


command! -complete=command -nargs=* Left vertical above <args>
command! -complete=command -nargs=* LEFT vertical topleft <args>
command! -complete=command -nargs=* Right vertical below <args>
command! -complete=command -nargs=* RIGHT vertical botright <args>
command! -complete=command -nargs=* Above above <args>
command! -complete=command -nargs=* ABOVE topleft <args>
command! -complete=command -nargs=* Below below <args>
command! -complete=command -nargs=* BELOW botright <args>
command! -complete=command -nargs=* Tab tab <args>
command! -complete=command -nargs=* Nosplit call window#NoSplitExec(<q-args>)
command! -complete=help -nargs=* Help vert help <args>
command! -complete=help -nargs=* H call window#NoSplitExec('help ' . <q-args>)

command! -complete=buffer -nargs=* Leftb vertical above sb <args>
command! -complete=buffer -nargs=* LEFTB vertical topleft sb <args>
command! -complete=buffer -nargs=* Rightb vertical below sb <args>
command! -complete=buffer -nargs=* RIGHTB vertical botright sb <args>
command! -complete=buffer -nargs=* Aboveb above sb <args>
command! -complete=buffer -nargs=* ABOVEB topleft sb <args>
command! -complete=buffer -nargs=* Belowb below sb <args>
command! -complete=buffer -nargs=* BELOWB botright sb <args>
command! -complete=buffer -nargs=* Tabb tab sb <args>
command! -nargs=+ WinSplit call window#MatrixSplit(<f-args>)
command! -nargs=* WinArg call window#EditArg(<f-args>)

" [range]Pview [buf]
command! -nargs=* -complete=buffer -range Pview call window#preview(<q-mods>, <line1>, <line2>, <f-args>)
" above 1,3Sview
" above 1,3Sview buf
command! -nargs=* -complete=buffer -range Sview call window#splitview(<q-mods>, <line1>, <line2>, <f-args>)
command! -nargs=? Vset call window#SetViewId(<q-args>) " bang -> append
command! Vclose call window#CloseView()
command! -nargs=0 -range Show call window#show_lines(<line1>, <line2>)
command! -range Top call window#SetTop(<line1>)


command! -nargs=1 PE pedit +/<args> %
command! -nargs=1 PED pedit +/\\\(class\\\|def\\\)\ <args> %

let g:vertical_dw=5
let g:horizontal_dw=5
nnoremap <A-a> :<C-U>exec "vert resize -". (g:vertical_dw * v:count1)<CR>
nnoremap <A-d> :<C-U>exec "vert resize +". (g:vertical_dw * v:count1)<CR>
nnoremap <A-w> :<C-U>exec      "resize -". (g:horizontal_dw * v:count1)<CR>
nnoremap <A-s> :<C-U>exec      "resize +". (g:horizontal_dw * v:count1)<CR>

command! Qw botright cw
command! Qo botright copen
command! Qc botright cclose


"with bang, also swap alternative buf
"SwapWin winnr1 winnr2
command! -bang -bar -nargs=+ SwapWin call window#swap_win(<bang>0, <f-args>)

" for this layout, default restore does not work (at least for cursor in
" window 2
" |-----|----|----|
" |     |    |    |
" |----------|    |
" |          |    |
" |---------------|
" :Zoom 3 1 2 4 will work
" args: specify the order of windows to be restored
command! -count -addr=windows -nargs=* Zoom call window#ZoomToggle(<line1>, <f-args>)
nnoremap <silent> <A-z> :<c-u>call window#zoom(v:count?v:count:winnr())<CR>
tnoremap <silent> <A-z> <c-\><c-n>:call window#zoom(v:count?v:count:winnr())<CR>a

nnoremap Q :call window#start_recording()<cr>
command! -register -addr=windows -range=% WinDoMacro call window#do_macro(<reg>, <line1>, <line2>)

command! -nargs=? Width exe 'vert resize' (<q-args> is ''? (&buftype == 'terminal' ? 154 : 120) : <q-args>)
command! -nargs=1 Height resize <args>
