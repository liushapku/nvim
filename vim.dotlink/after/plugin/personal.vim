"noremap <leader>f <Plug>(easymotion-bd-f)
"noremap <leader>t <Plug>(easymotion-bd-f)
"nmap f <Plug>(easymotion-bd-f)
"map F <Plug>(easymotion-overwin-f)
"nmap t <Plug>(easymotion-bd-t)
"map T <Plug>(easymotion-overwin-T)
"map w <Plug>(easymotion-bd-w)
"map W <Plug>(easymotion-overwin-w)
"map b <Plug>(easymotion-bd-b)
"map B <Plug>(easymotion-overwin-B)
"map e <Plug>(easymotion-bd-e)
"map E <Plug>(easymotion-overwin-E)
"map ge <Plug>(easymotion-bd-ge)
"map gE <Plug>(easymotion-overwin-gE)
"map j <Plug>(easymotion-sol-j)
"map k <Plug>(easymotion-sol-k)
"nmap <leader>n <Plug>(easymotion-bd-n)
"map N <Plug>(easymotion-overwin-N)
"map s <Plug>(easymotion-s)


let g:ctrlp_regexp = 0
"nmap <C-S-P> :<C-U>CtrlP



"let g:airline_section_b='%{airline#util#wrap(airline#extensions#hunks#get_hunks(),0)}%{airline#util#wrap(airline#extensions#branch#get_head(),0)}'
"let g:airline_section_b='%{airline#util#wrap(airline#extensions#hunks#get_hunks(),0)}%{airline#util#wrap(fugitive#statusline(),0)}'
let g:airline_section_b='%{airline#util#wrap(airline#extensions#hunks#get_hunks(),0)}%{airline#util#wrap(g:airline_symbols.branch .'' ''. fugitive#statusline(),0)}'


"with bang, it will send <c-u> which clears the input
"command! -complete=shellcmd -bang -count=0 -nargs=* Td  silent call Tdo(<count>, <bang>0, <q-args>)
"function! Tdo(n, clear, cmd)
"    let n = a:n == 0? g:current_neoterm : a:n
"    let cmd = len(a:cmd) == 0? "\<c-p>" : a:cmd
"    if a:clear
"        let cmd = "\<c-u>" . cmd
"    endif
"    call g:neoterm.instances[n].do(cmd)
"endfunction
"command! Tn
"\ let g:current_neoterm = g:neoterm.last_id + 1 |
"\ silent call neoterm#new({'mod': <q-mods>}) |
"\ call airline#extensions#tabline#buffers#invalidate()
"command! TNEW let g:neoterm_split_on_tnew=0 | exe "Tnew" | let g:neoterm_split_on_tnew=1
"silent! nunmap ;pw

" from eunuch, change bd to BD
function! s:Delete(name)
  let file = fnamemodify(bufname(a:name),':p')
  BD!
  if !bufloaded(file) && delete(file)
      echoerr 'Failed to delete "'.file.'"'
  endif
endfunction
command! Delete call s:Delete(<q-args>)

cmap <a-b> <esc>b
cmap <a-f> <esc>f

hi Normal guibg=grey10
hi Pmenu guifg=Blue guibg=Violet
hi DiffChange guibg=gray30
hi DiffText guibg=DarkViolet

"=======vim-diff-enhanced
EnhancedDiff patience
