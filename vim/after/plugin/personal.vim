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

syntax on
hi DiffAdd guifg=violet
hi DiffDelete guifg=violet
hi DiffChange guifg=PowderBlue
hi DiffText guifg=LightYellow

"=======vim-diff-enhanced
EnhancedDiff patience

set completeopt=menuone,longest,preview
set guicursor=
set background=dark
