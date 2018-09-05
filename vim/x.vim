"let g:plug_url_format="git@github.com:%s.git"
let g:plug_url_format="https://github.com/%s.git"
set rtp+=~/repos/jupyter_nvim
call plug#begin('~/.vim/bundle')

"Plug 'liushapku/jupyter_nvim', { 'do': ':UpdateRemotePlugins' }
"Plug '~/repos/jupyter_nvim'
Plug 'tpope/vim-fugitive'              " git
Plug 'liushapku/webapi-vim'            " webapi
Plug 'liushapku/gist-vim'              " gist
Plug 'kien/ctrlp.vim'                  " file lookup
Plug 'majutsushi/tagbar'               " tag generation and listing
Plug 'scrooloose/nerdcommenter'        " comment and uncomment text
Plug 'houtsnip/vim-emacscommandline'   " emacs keybinding in command mode
Plug 'tommcdo/vim-exchange'            " exchange two strings
Plug 'liushapku/vim-operator-user'     " user defined operator
Plug 'kana/vim-operator-replace'       " replace as a operator
Plug 'raimondi/delimitmate'            " autocompletion for quotes, brackets...
Plug 'tpope/vim-surround'              " surround text using [( etc
Plug 'tpope/vim-unimpaired'            " navigate using [ and ]
Plug 'tpope/vim-eunuch'                " os actions like Delete and Remove
Plug 'tpope/vim-repeat'                " enable repeat user defined editing
Plug 'gioele/vim-autoswap'             " handles swap files
Plug 'qpkorr/vim-bufkill'              " handle window after buf is deleted
Plug 'vim-airline/vim-airline'         " statsline
Plug 'vim-airline/vim-airline-themes'  " statsline
Plug 'bronson/vim-trailing-whitespace' " trailing whitespace
Plug 'peterrincker/vim-argumentative'  " nativate in parameter list and change order
Plug 'mbbill/undotree'                 " undo tree
Plug 'scrooloose/nerdtree'             " directory tree
Plug 'jistr/vim-nerdtree-tabs'         " directory tree
Plug 'tpope/vim-abolish'               " language friendly searches, substitutions, and abbreviations
Plug 'liushapku/vim-colorschemes'      " color scheme for gruvbox
Plug 'kassio/neoterm'                  " terminal
Plug 'kana/vim-textobj-user'           " user defined textobject
Plug 't9md/vim-quickhl'                " quick highlight
Plug 'andrewradev/linediff.vim'        " diff blocks and merge
Plug 'chrisbra/vim-diff-enhanced'      " smart diff
Plug 'junkblocker/patchreview-vim'     " ????
Plug 'skywind3000/asyncrun.vim'        " asyncrun shell commands
Plug 'mhinz/vim-signify'               " show symbols at the leftmost columns
Plug 'wesq3/vim-windowswap'            " swap windows
Plug 'easymotion/vim-easymotion'       " easily move by selection
Plug 'mhinz/vim-startify'              " session management
Plug 'godlygeek/tabular'               " tabularize using delimiters
Plug 'jeetsukumaran/vim-indentwise'
Plug 'chrisbra/colorizer'


" search
Plug 'junegunn/fzf', {'do': './install --all'}
Plug 'junegunn/fzf.vim'
Plug 'pbogut/fzf-mru.vim'

" Complete
Plug 'SirVer/ultisnips'                                       " snippets framework
Plug 'honza/vim-snippets'                                     " predefined snippets
Plug 'Shougo/echodoc.vim'
Plug 'davidhalter/jedi-vim'                                   " vim jump
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'zchee/deoplete-jedi'                                    " deoplete complete source for python
Plug 'Shougo/neco-vim'                                        " deoplete complete source for vim
Plug 'rip-rip/clang_complete'                                 " deoplete complete source for c/c++


" filetype extensions
Plug 'lambacck/python_matchit'  " matchit for python
Plug 'vim-scripts/dbext.vim'    " database
Plug 'chrisbra/csv.vim'
Plug 'mattn/calendar-vim'
Plug 'jceb/vim-orgmode'
Plug 'tpope/vim-speeddating'
Plug 'peterhoeg/vim-qml'        " Qt
Plug 'elzr/vim-json'            " json
Plug 'moll/vim-node'            " nodejs
Plug 'pangloss/vim-javascript'  " javascript
Plug 'glench/vim-jinja2-syntax' " html
Plug 'mattn/emmet-vim'          " html


" always load as the very last one
"Plug 'ryanoasis/vim-devicons'
call plug#end()

"===ENDPLUG===

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

" fzf
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

nnoremap <c-p>  :<c-u>Files<cr>
nnoremap <c-p>~ :<c-u>Files ~/<cr>
nnoremap <c-p>: :<c-u>History :<cr>
nnoremap <c-p>/ :<c-u>History /<cr>
nnoremap <c-p>b :<c-u>Buffers<cr>
nnoremap <c-p>c :<c-u>Files $CONDA_PREFIX/lib/python3.*/site-packages<cr>
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

" gist
let g:gist_list_vsplit = 1
let g:gist_show_privates = 1
let g:gist_post_private = 0
let g:gist_open_browser_after_post = 1
let g:gist_detect_filetype = 1

" make AsyncRun
command! -bang -nargs=* -complete=file Make AsyncRun -program=make @ <args>

" Tagbar
nmap <F6> :TagbarOpen fjc<CR>
"nmap <F6> :TagbarToggle<CR>
let g:tagbar_left=1
let g:tagbar_width=30

" NERDTree
let g:NERDTreeShowBookmarks=1
let g:NERDTreeChDirMode=2
let g:NERDTreeIgnore=['\~$', '__pycache__']



" Airline
autocmd CompleteDone * AirlineRefresh
let g:airline#extensions#disable_rtp_load = 1
let g:airline_extensions = [
            \'branch',
            \'tabline',
            \'ctrlp',
            \'quickfix',
            \'tagbar',
            \'hunks',
            \'undotree',
            \'windowswap',
            \]
let g:airline#extensions#tabline#enabled=1
let g:airline#extensions#tabline#show_buffers=1
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#tabline#exclude_preview = 1
let g:airline#extensions#tabline#tab_nr_type = 2 " tab number
let g:airline#extensions#tabline#show_tab_type = 1
let g:airline#extensions#tabline#fnamemod =':t'
let g:airline#extensions#tabline#fnametruncate = 16
let g:airline#extensions#tabline#fnamecollapse = 2
let g:airline#extensions#tabline#buffer_idx_mode = 1
let g:airline#extensions#tabline#buffer_idx_format = {
      \ '0'  : '⁰',  '1'  : '¹',  '2'  : '²',  '3'  : '³',  '4'  : '⁴',
      \ '5'  : '⁵',  '6'  : '⁶',  '7'  : '⁷',  '8'  : '⁸',  '9'  : '⁹',
      \ '10' : '⁰',  '11' : '¹',  '12' : '²',  '13' : '³',  '14' : '⁴',
      \ '15' : '⁵',  '16' : '⁶',  '17' : '⁷',  '18' : '⁸',  '19' : '⁹',
      \ '20' : '⁰',  '21' : '¹',  '22' : '²',  '23' : '³',  '24' : '⁴',
      \ '25' : '⁵',  '26' : '⁶',  '27' : '⁷',  '28' : '⁸',  '29' : '⁹'
      \ }

let g:airline#extensions#windowswap#enabled = 1
let g:airline#extensions#windowswap#indicator_text = 'WS'
"let g:airline_section_b='%{airline#util#wrap(airline#extensions#hunks#get_hunks(),0)}%{airline#util#wrap(airline#extensions#branch#get_head(),0)}'

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
"let g:airline_left_sep = '»'
"let g:airline_left_sep = '▶'
"let g:airline_right_sep = '«'
"let g:airline_right_sep = '◀'
let g:airline_symbols.crypt = '🔒'
"let g:airline_symbols.space = ''
"let g:airline_symbols.linenr = '␊'
"let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = ''
"let g:airline_symbols.linenr = '¶'
"let g:airline_symbols.maxlinenr = '☰'
let g:airline_symbols.maxlinenr = ''
let g:airline_symbols.branch = '⎇'
"let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
"let g:airline_symbols.paste = '∥'
let g:airline_symbols.spell = 'Ꞩ'
let g:airline_symbols.notexists = '∄'
let g:airline_symbols.whitespace = 'Ξ'

let g:airline_powerline_fonts = 1
"let g:airline_left_sep = ''
"let g:airline_left_alt_sep = ''
"let g:airline_right_sep = ''
"let g:airline_right_alt_sep = ''
"let g:airline_symbols.branch = ''
"let g:airline_symbols.readonly = ''
"let g:airline_symbols.linenr = '☰'
"let g:airline_symbols.maxlinenr = ''

"=========vim-signify
let g:signify_realtime = 1
let g:signify_cursorhold_insert = 0
let g:signify_cursorhold_normal = 0
let g:signify_vcs_list = ['git']


" operator-replace
"nmap gp :<C-U>silent call operator#user#_set_up('operator#replace#do')<cr>g@
"vmap gp :<C-U>silent call operator#user#_set_up('operator#replace#do')<CR>gvg@
"nmap gpp gpg@
nmap gp <Plug>(operator-replace)
vmap gp <Plug>(operator-replace)  " the same as p
nmap gpp gp_
nmap ;P ^Pa<space><esc>
nmap ;p $a<space><esc>p


" neoterm
let g:neoterm_default_mod='vertical'
let g:term_autoinsert = 1
let g:neoterm_autoscroll=1



" futgitive
command! GInitDir call fugitive#detect(resolve(expand('%:h')))
autocmd BufReadPost fugitive://* set bufhidden=delete
"set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P
"

" undotree
nnoremap <f8> :<C-U>UndotreeToggle<cr>


"======quickhl
nmap <Space>m <Plug>(quickhl-manual-this)
xmap <Space>m <Plug>(quickhl-manual-this)
nmap <Space>w <Plug>(quickhl-cword-toggle)
xmap <Space>w <Plug>(quickhl-cword-toggle)
nmap <Space>M <Plug>(quickhl-manual-reset)
xmap <Space>M <Plug>(quickhl-manual-reset)
map <Space>h <Plug>(operator-quickhl-manual-this-motion)
command! -bang -nargs=1 Hll  :call quickhl#manual#add("^.*" . <q-args> . ".*$", <bang>1)
command! -bang -nargs=* Hlld  :call quickhl#manual#del(map(<q-args>, '"^.*" . v:val . ".*$"'), <bang>1)
command! -bang -nargs=1 Hl   :call quickhl#manual#add(<q-args>, <bang>1)
command! -bang -nargs=* Hld  :call quickhl#manual#del(<q-args>, <bang>1)

"nmap <Space>j <Plug>(quickhl-cword-toggle)
"nmap <Space>] <Plug>(quickhl-tag-toggle)


let g:extra_whitespace_ignored_filetypes = ['unite', 'markdown']

"======startify
let g:startify_session_dir = '~/.vim/session'
let g:startify_skiplist = [
    \ '.git/*',
    \ ]
let g:startify_lists = [
      \ { 'type': 'sessions',  'header': ['   Sessions']       },
      \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
      \ { 'type': 'files',     'header': ['   MRU']            },
      \ { 'type': 'commands',  'header': ['   Commands']       },
      \ ]
      "\ { 'type': 'dir',       'header': ['   MRU '. getcwd()] },
let g:startify_bookmarks = [
    \ {'x': '~/.vim/x.vim'},
    \ {'o': '~/.vim/plugin/others.vim'},
    \ '$WORKSPACE/scripts/stock-lasso-fit',
    \ ]
let g:startify_enable_special      = 0
let g:startify_files_number        = 20
let g:startify_relative_path       = 1
let g:startify_change_to_dir       = 0
let g:startify_update_oldfiles     = 1
let g:startify_session_autoload    = 1
let g:startify_session_persistence = 1
let g:startify_commands = [
    \ ['Vim Reference', 'h ref'],
    \ {'f': ['fzf files', 'Files']},
    \ {'m': ['My magical function', 'call Magic()']},
    \ ]

"=======autopep8
let g:autopep8_diff_type='horizontal'
let g:autopep8_disable_show_diff=1


"=======orgmode
let g:org_agenda_files = ['~/dotfiles/org/*.org']
let g:org_heading_shade_leading_stars = 0
let g:org_aggressive_conceal = 1
let g:org_tag_column= 120

"=======indent-guides
nmap <silent> <space>i <Plug>IndentGuidesToggle

"=======nerdcommenter
let g:NERDDefaultAlign = 'left'
let g:NERDCustomDelimiters = {
    \ 'input': {'left': '# '}
\ }

"=======Exchange
vmap cx <Plug>(Exchange)

"=======DelimitMate
let delimitMate_balance_matchpairs = 1
"let delimitMate_excluded_regions = "Comment,String"
let delimitMate_expand_cr = 2


" dbext
let g:dbext_default_profile_pgsql = 'type=PGSQL'
let g:dbext_default_profile = 'pgsql'
let g:dbext_default_use_sep_result_buffer = 1

" surround
imap ;ys <esc>lys
imap ;yss <esc>lyss
imap ;yS <esc>lyS
imap ;ySS <esc>lySS


" vim-json
let g:vim_json_syntax_conceal = 0

"===========emmet
let g:user_emmet_settings = {
\    'html': {
\        'empty_element_suffix': ' />',
\    },
\}

"============ linediff
vmap <c-d> :Linediff<cr>

"=============colorschemes
colorscheme gruvbox

