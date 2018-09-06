nnoremap <a-0> :<C-U>call buffer#show(v:count * 10 + 0)<CR>
nnoremap <a-1> :<c-u>call buffer#show(v:count * 10 + 1)<CR>
nnoremap <a-2> :<C-U>call buffer#show(v:count * 10 + 2)<CR>
nnoremap <a-3> :<C-U>call buffer#show(v:count * 10 + 3)<CR>
nnoremap <a-4> :<C-U>call buffer#show(v:count * 10 + 4)<CR>
nnoremap <a-5> :<C-U>call buffer#show(v:count * 10 + 5)<CR>
nnoremap <a-6> :<C-U>call buffer#show(v:count * 10 + 6)<CR>
nnoremap <a-7> :<C-U>call buffer#show(v:count * 10 + 7)<CR>
nnoremap <a-8> :<C-U>call buffer#show(v:count * 10 + 8)<CR>
nnoremap <a-9> :<C-U>call buffer#show(v:count * 10 + 9)<CR>
nnoremap <a-[> :<C-U>call buffer#next(0)<CR>
nnoremap <a-]> :<C-U>call buffer#next(1)<CR>
tmap <a-0><a-0> <c-\><c-n><a-0>
tmap <a-1><a-1> <c-\><c-n><a-1>
tmap <a-2><a-2> <c-\><c-n><a-2>
tmap <a-3><a-3> <c-\><c-n><a-3>
tmap <a-4><a-4> <c-\><c-n><a-4>
tmap <a-5><a-5> <c-\><c-n><a-5>
tmap <a-6><a-6> <c-\><c-n><a-6>
tmap <a-7><a-7> <c-\><c-n><a-7>
tmap <a-8><a-8> <c-\><c-n><a-8>
tmap <a-9><a-9> <c-\><c-n><a-9>
tmap <a-[> <c-\><c-n><a-[>
tmap <a-]> <c-\><c-n><a-]>
tmap <esc>#     <c-\><c-n>:b#<cr>

" switch to alternative buffer
nnoremap gb :<C-U>exec "b" . (v:count==0? "#":v:count)<CR>
" switch to previous window or (when count is present) go to window n
nnoremap <silent> <expr> gw v:count==0?"\<C-W>p":"\<C-W>\<C-W>"
nnoremap gc <C-W>c
" goto preview window
nnoremap gW <C-W>P
tnoremap <esc>: <c-\><c-n>:

command! -bar -narg=0 Cd exe 'cd' expand('%:p:h')
nmap <leader>cd :<C-U>silent exec "lcd " . expand('%:p:h')<bar>pwd<CR>

command! WipeNoName call buffer#wipe_noname()

command! -count -addr=windows -nargs=+ -complete=command	WE call buffer#WinExec(v:count, <f-args>)
command! -nargs=+ -complete=command	WEE call buffer#WinExecAll(<f-args>)
command! -nargs=+ -complete=command	BE call buffer#BufExec(<f-args>)
command! -nargs=+ -complete=command	VE call buffer#ViewExec(<q-args>)
command! -nargs=+ -complete=command	RE call buffer#RegExec(<f-args>)
command! -nargs=0 E call buffer#ViewExec('edit')

" select a subset of buffers to construct args list
command! -nargs=1 Args call buffer#arg_select(<q-args>, 'args')
" select a subset of buffers to append to args list
command! -nargs=1 Argadd call buffer#arg_select(<q-args>, 'append')
" delete a subset of buffers from args list
command! -nargs=1 Argdelete call buffer#arg_select(<q-args>, 'delete')
" select a subset of buffers to construct local args list
command! -nargs=1 Arglocal call buffer#arg_select(<q-args>, 'local')

command! -bang FtPlug <mods> execute (<q-mods> . " new " . buffer#ftplugin_location(<bang>0))
