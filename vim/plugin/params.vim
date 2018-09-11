
"nmap  ;a vi,
"imap  ;a <esc>],;a
"xmap  ;a <esc>],;a
noremap  ;a :<c-u>call params#SelectNextPara(v:count1)<cr>
snoremap ;a <esc>:call params#SelectNextPara(v:count1)<cr>
inoremap ;a <c-o>:call params#SelectNextPara(v:count1)<cr>
noremap  ;b :<c-u>call params#SelectNextEqual(v:count1)<cr>
snoremap ;b <esc>:call params#SelectNextEqual(v:count1)<cr>
inoremap ;b <c-o>:call params#SelectNextEqual(v:count1)<cr>

noremap  ;A :<c-u>call params#SelectPrevPara(v:count1)<cr>
snoremap ;A <esc>:call params#SelectPrevPara(v:count1)<cr>
inoremap ;A <c-o>:call params#SelectPrevPara(v:count1)<cr>
noremap  ;B :<c-u>call params#SelectPrevEqual(v:count1)<cr>
snoremap ;B <esc>:call params#SelectPrevEqual(v:count1)<cr>
inoremap ;B <c-o>:call params#SelectPrevEqual(v:count1)<cr>
nnoremap g( :<c-u>call params#GotoFunction(v:count1)<cr>
nnoremap g) :<c-u>call params#GotoFunctionEnd(v:count1)<cr>
nnoremap ( F(
nnoremap ) f)

inoremap ;, <end>,
nnoremap ;, A,<esc>
imap ,) <esc>lys$)
nmap ,) ys$)
imap <c-x>) <c-r>=params#Complete()<cr>
imap ;) <c-r>=params#Complete()<cr>
imap <silent> <a-;> <Cmd>call params#Echo()<cr>
"imap <silent> <expr> <a-;> jedi#show_call_signatures()?"":""


nnoremap <silent> , :<c-u>call params#GotoNextPara(v:count1)<cr>
nnoremap <silent> g; :<c-u>call params#GotoPrevPara(v:count1)<cr>
nnoremap <space>, ,
nnoremap <space><space> ;

call operator#user#define('InsertSurround', 'params#Surround')

imap ;s <esc>l<Plug>(operator-InsertSurround)
imap ;S <esc><Plug>(operator-InsertSurround)


