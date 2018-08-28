
"nmap  ;a vi,
"imap  ;a <esc>],;a
"xmap  ;a <esc>],;a
noremap  ;a :<c-u>call params#SelectNextPara()<cr>
snoremap ;a <esc>:call params#SelectNextPara()<cr>
inoremap ;a <c-o>:call params#SelectNextPara()<cr>
noremap  ;b :<c-u>call params#SelectNextEqual()<cr>
snoremap ;b <esc>:call params#SelectNextEqual()<cr>
inoremap ;b <c-o>:call params#SelectNextEqual()<cr>

noremap  ;A :<c-u>call params#SelectPrevPara()<cr>
snoremap ;A <esc>:call params#SelectPrevPara()<cr>
inoremap ;A <c-o>:call params#SelectPrevPara()<cr>
noremap  ;B :<c-u>call params#SelectPrevEqual()<cr>
snoremap ;B <esc>:call params#SelectPrevEqual()<cr>
inoremap ;B <c-o>:call params#SelectPrevEqual()<cr>
nnoremap ( :<c-u>call params#GotoFunction(v:count1)<cr>
nnoremap ) :<c-u>call params#GotoFunctionEnd(v:count1)<cr>
nnoremap g( F(
nnoremap g) f)
nnoremap [( F(
nnoremap ]( f(

imap <a-9> <c-r>=params#Echo()?'':''<cr>
imap ;) <c-r>=params#Complete(1)<cr>


nnoremap <silent> , :<c-u>call params#GotoNextPara()<cr>
nnoremap <silent> g, :<c-u>call params#GotoPrevPara()<cr>
nnoremap <space>, ,
nnoremap <space><space> ;
