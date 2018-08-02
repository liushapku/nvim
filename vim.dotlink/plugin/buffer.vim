nnoremap <a-0> :<C-U>call buffer#BufferAt(v:count * 10 + 0)<CR>
nnoremap <a-1> :<c-u>call buffer#BufferAt(v:count * 10 + 1)<CR>
nnoremap <a-2> :<C-U>call buffer#BufferAt(v:count * 10 + 2)<CR>
nnoremap <a-3> :<C-U>call buffer#BufferAt(v:count * 10 + 3)<CR>
nnoremap <a-4> :<C-U>call buffer#BufferAt(v:count * 10 + 4)<CR>
nnoremap <a-5> :<C-U>call buffer#BufferAt(v:count * 10 + 5)<CR>
nnoremap <a-6> :<C-U>call buffer#BufferAt(v:count * 10 + 6)<CR>
nnoremap <a-7> :<C-U>call buffer#BufferAt(v:count * 10 + 7)<CR>
nnoremap <a-8> :<C-U>call buffer#BufferAt(v:count * 10 + 8)<CR>
nnoremap <a-9> :<C-U>call buffer#BufferAt(v:count * 10 + 9)<CR>
nnoremap <a--> :<C-U>call buffer#BufferNext(0)<CR>
nnoremap <a-=> :<C-U>call buffer#BufferNext(1)<CR>
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
tmap <esc>#     <c-\><c-n>:b#<cr>
tmap <F2> <c-\><c-n>:b<space>

nnoremap gb :<C-U>exec "b" . (v:count==0? "#":v:count)<CR>
nnoremap <silent> <expr> gw v:count==0?"\<C-W>p":"\<C-W>\<C-W>"
nnoremap gW <C-W>P
tnoremap <esc>: <c-\><c-n>:

command! TTab call buffer#TermsToTab()
command! -bar -narg=0 Cd exe 'cd' expand('%:p:h')

function! g:Jobid(num)
    return buffer#NeotermJobid(a:num)
endfunction


"Copy from Ipython in and out
command! -bang -nargs=* -range=-1 Tcp call append(MagicRange(<count>), buffer#CopyIPython(<bang>0, <f-args>))
command! -bar Tl Tline
command! -range -bang Tpy <line1>,<line2>call buffer#SendToIPython(0, <bang>0)
command! -range -bang Tipy <line1>,<line2>call buffer#SendToIPython(1, <bang>0)


" bang: only cd for the latest terminal. without bang, cd for all terminal
command! -nargs=? -complete=dir -bang Tcd call buffer#Cd(<q-args>, <bang>0)
command! -nargs=1 Tb exe "b neoterm-" . <args>
command! -count=0 -complete=shellcmd -nargs=* Tt <count>TS | T <args>
command! -nargs=0 Tc T 

command! WipeNoName call buffer#WipeNoName()


command! -nargs=+ -complete=command	WE call buffer#WinExec(<f-args>)
command! -nargs=+ -complete=command	WEE call buffer#WinExecAll(<f-args>)
command! -nargs=+ -complete=command	BE call buffer#BufExec(<f-args>)
command! -nargs=+ -complete=command	VE call buffer#ViewExec(<q-args>)
command! -nargs=+ -complete=command	RE call buffer#RegExec(<f-args>)
command! -nargs=0 E call buffer#ViewExec('edit')

command! -nargs=1 Args call buffer#Select(<q-args>, 'args')
command! -nargs=1 Argadd call buffer#Select(<q-args>, 'append')
command! -nargs=1 Argselect call buffer#Select(<q-args>, 'replace')
command! -nargs=1 Arglocal call buffer#Select(<q-args>, 'local')


function! Tempname()
    return buffer#Tempname()
endfunction
