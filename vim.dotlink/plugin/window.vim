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
imap <a-[> <a-pageup>
imap <a-]> <a-pagedown>
nmap <a-[> <a-pageup>
nmap <a-]> <a-pagedown>
tmap <a-[> <a-pageup>
tmap <a-]> <a-pagedown>

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


command! -complete=command -nargs=* LeftE vertical above <args>
command! -complete=command -nargs=* LEFTE vertical topleft <args>
command! -complete=command -nargs=* RightE vertical below <args>
command! -complete=command -nargs=* RIGHTE vertical botright <args>
command! -complete=command -nargs=* AboveE above <args>
command! -complete=command -nargs=* ABOVEE topleft <args>
command! -complete=command -nargs=* BelowE below <args>
command! -complete=command -nargs=* BELOWE botright <args>
command! -complete=command -nargs=* TabE tab <args>
command! -complete=command -nargs=* Nosplit call window#NoSplitExec(<q-args>)
command! -complete=help -nargs=* Help call window#NoSplitExec('help ' . <q-args>)
command! -complete=help -nargs=* H call window#NoSplitExec('help ' . <q-args>)

command! -complete=buffer -nargs=* Left vertical above sb <args>
command! -complete=buffer -nargs=* LEFT vertical topleft sb <args>
command! -complete=buffer -nargs=* Right vertical below sb <args>
command! -complete=buffer -nargs=* RIGHT vertical botright sb <args>
command! -complete=buffer -nargs=* Above above sb <args>
command! -complete=buffer -nargs=* ABOVE topleft sb <args>
command! -complete=buffer -nargs=* Below below sb <args>
command! -complete=buffer -nargs=* BELOW botright sb <args>
command! -complete=buffer -nargs=* Tab tab sb <args>
command! -nargs=+ WinSplit call window#MatrixSplit(<f-args>)
command! -nargs=* WinArg call window#EditArg(<f-args>)

command! -nargs=* -complete=buffer -range Pview call window#Preview(<q-mods>, <line1>, <line2>, <f-args>)
" above 1,3Sview
" above 1,3Sview buf
command! -nargs=* -complete=buffer -range Vopen call window#Splitview(<q-mods>, <line1>, <line2>, <f-args>)
command! -nargs=? Vset call window#SetViewId(<q-args>) " bang -> append
command! Vclose call window#CloseView()
command! -nargs=0 -range Show call window#Show(<line1>, <line2>)
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

nnoremap Q :call window#StartRecording()<cr>

"command! -count=0 SwapWith call window#SwapWith(<count>)
"with bang, also swap alternative buf
command! -bang -bar -nargs=+ SwapWin call window#SwapWin(<bang>0, <f-args>)

" for this layout, default restore does not work (at least for cursor in
" window 2
" |-----|----|----|
" |     |    |    |
" |----------|    |
" |          |    |
" |---------------|
" :Zoom 3 1 2 4 will work
" args: specify the order of windows to be restored
command! -range -addr=windows -nargs=* Zoom call window#ZoomToggle(<line1>, <f-args>)
nnoremap <silent> <A-z> :<c-u>call window#ZoomToggle(v:count?v:count:winnr())<CR>
tnoremap <silent> <A-z> <c-\><c-n>:call window#ZoomToggle(v:count?v:count:winnr())<CR>a
command! -register WinRun call window#MacroDo(<reg>)

command! -nargs=? Width exe 'vert resize' (<q-args> is ''? (&buftype == 'terminal' ? 154 : 120) : <q-args>)
command! -nargs=1 Height resize <args>
