" CtrlP
let g:ctrlp_map = '<c-p><c-p>'
let g:ctrlp_by_filename = 0
let g:ctrlp_use_caching = 1
let g:ctrlp_working_path_mode='ra'
let g:ctrlp_open_multiple_files = '2vjr'
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_cache_dir = $HOME.'/.cache/ctrlp'
let g:ctrlp_open_new_file = 'r'
let g:ctrlp_custom_ignore= {
    \ 'dir':'__pycache__',
    \ 'file':'*.swp'
    \ }

nnoremap <c-p>P :<c-u>CtrlP<cr>
nnoremap <c-p>B :<c-u>CtrlPBuffer<cr>
nnoremap <c-p>C :<c-u>CtrlP $CONDA_PREFIX/lib/python3.*/site-packages<cr>
nnoremap <c-p>D :<c-u>CtrlP ~/dotfiles<cr>
nnoremap <c-p>H :<c-u>CtrlP ~/<cr>
nnoremap <c-p>M :<c-u>CtrlPMRUFiles<cr>
nnoremap <c-p>Q :<c-u>CtrlPQuickfix<cr>
nnoremap <c-p>U :<c-u>CtrlPUndo<cr>
nnoremap <c-p>V :<c-u>CtrlP ~/repos/nvim/vim.dotlink<cr>
nnoremap <c-p>W :<c-u>CtrlP $WORKSPACE<cr>

" fzf ======================================================================
function! s:FilesConda()
  if $CONDA_PREFIX != ''
    let conda= $CONDA_PREFIX
  elseif $HOSTNAME =~ '^liusha'
    let conda= $HOME. '/miniconda3'
  else
    let conda= $HOME. '/conda'
  endif
  let conda .= '/lib/python3.*/site-packages'
  exe 'Files' conda
endfunction
nnoremap <c-p>  :<c-u>Files<cr>
nnoremap <c-p>~ :<c-u>Files ~/<cr>
nnoremap <c-p>: :<c-u>History :<cr>
nnoremap <c-p>/ :<c-u>History /<cr>
nnoremap <c-p>b :<c-u>Buffers<cr>
nnoremap <c-p>c :<c-u>call <SID>FilesConda()<cr>
nnoremap <c-p>d :<c-u>Files ~/dotfiles<cr>
nnoremap <c-p>g :<c-u>History<cr>
nnoremap <c-p>h :<c-u>History<cr>
nnoremap <c-p>k :<c-u>Marks<cr>
nnoremap <c-p>l :<c-u>BLines<cr>
nnoremap <c-p>L :<c-u>Lines<cr>
nnoremap <c-p>m :<c-u>FZFMru<cr>
nnoremap <c-p>M :<c-u>FZFMru <c-r>=expand('%:e')<cr>$<cr>
nnoremap <c-p>n :<c-u>Snippets<cr>
nnoremap <c-p>s :<c-u>Startify<cr>
nnoremap <c-p>t :<c-u>BTags<cr>
nnoremap <c-p>T :<c-u>Tags<cr>
nnoremap <c-p>v :<c-u>Files ~/repos/nvim/vim<cr>
nnoremap <c-p>w :<c-u>Files $WORKSPACE<cr>

command! -bang -nargs=* Ag
  \ call fzf#vim#ag(<q-args>,
  \                 <bang>0 ? fzf#vim#with_preview('up:60%')
  \                         : fzf#vim#with_preview('right:50%', '?'),
  \                 <bang>0)

function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction
let g:fzf_layout = {'down': '~50%'}
let g:fzf_action = {
  \ 'ctrl-q': function('s:build_quickfix_list'),
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

command! L call fzf#run(fzf#wrap('*lines*', {
      \ 'source': getline(1, line('$')),
      \ 'sink':   {line-> scripting#echo(line)},
      \ }, 0))
