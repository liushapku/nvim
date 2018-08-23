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

"let g:airline_section_b='%{airline#util#wrap(airline#extensions#hunks#get_hunks(),0)}%{airline#util#wrap(airline#extensions#branch#get_head(),0)}'
"let g:airline_section_b='%{airline#util#wrap(airline#extensions#hunks#get_hunks(),0)}%{airline#util#wrap(fugitive#statusline(),0)}'
let g:airline_section_b='%{airline#util#wrap(airline#extensions#hunks#get_hunks(),0)}%{airline#util#wrap(g:airline_symbols.branch .'' ''. fugitive#statusline(),0)}'


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

hi Normal guifg=white guibg=black
hi Pmenu guifg=Blue guibg=Violet

hi DiffAdd guifg=violet
hi DiffDelete guifg=violet
hi DiffChange guifg=PowderBlue
hi DiffText guifg=LightYellow

"=======vim-diff-enhanced
EnhancedDiff patience
syntax on
