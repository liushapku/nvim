call plug#begin('~/.vim/bundle')
Plug 'neovim/python-client', { 'do': ':UpdateRemotePlugins' }
Plug 'tpope/vim-fugitive'

" database
Plug 'vim-scripts/dbext.vim'

Plug 'jeetsukumaran/vim-indentwise'
Plug 't9md/vim-quickhl'
Plug 'skywind3000/asyncrun.vim'
Plug 'qpkorr/vim-bufkill'
Plug 'easymotion/vim-easymotion'
Plug 'scrooloose/nerdtree'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'chrisbra/csv.vim'
Plug 'mattn/calendar-vim'
Plug 'mattn/webapi-vim'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-eunuch'
Plug 'jceb/vim-orgmode'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-abolish'  " language friendly searches, substitutions, and abbreviations
Plug 'kien/ctrlp.vim'
Plug 'majutsushi/tagbar'
Plug 'scrooloose/nerdcommenter'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'mhinz/vim-signify'
Plug 'mbbill/undotree'
Plug 'bronson/vim-trailing-whitespace'
Plug 'tommcdo/vim-exchange'
Plug 'godlygeek/tabular'
Plug 'kana/vim-operator-user'
Plug 'kana/vim-operator-replace'
Plug 'peterrincker/vim-argumentative'
Plug 'hynek/vim-python-pep8-indent'
Plug 'wesq3/vim-windowswap'
Plug 'houtsnip/vim-emacscommandline'
Plug 'raimondi/delimitmate'

"diff
Plug 'chrisbra/vim-diff-enhanced'
Plug 'andrewradev/linediff.vim'
Plug 'junkblocker/patchreview-vim'

"python
Plug 'tell-k/vim-autopep8'
Plug 'nvie/vim-flake8'
"javascript
Plug 'pangloss/vim-javascript'

"html
"Plug 'othree/html5.vim'
Plug 'glench/vim-jinja2-syntax'
"Plug 'docunext/closetag.vim'
Plug 'mattn/emmet-vim'
let g:user_emmet_settings = {
\    'html': {
\        'empty_element_suffix': ' />',
\    },
\}

"Colors
Plug 'tomasr/molokai'
Plug 'altercation/vim-colors-solarized'
Plug 'iCyMind/NeoSolarized'
Plug 'vim-scripts/ArgsAndMore'
Plug 'vim-scripts/ingo-library'

Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'shougo/vimproc.vim', {'do': 'make'}
Plug 'kassio/neoterm'
Plug 'shougo/unite.vim'
Plug 'shougo/neoyank.vim'
Plug 'kana/vim-textobj-user'
Plug 'bfredl/nvim-ipy', { 'do': ':UpdateRemotePlugins' }

" Complete
"Plug 'Shougo/denite.nvim',   { 'do': ':UpdateRemotePlugins' }
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'zchee/deoplete-jedi'
Plug 'Shougo/echodoc.vim'
Plug 'davidhalter/jedi-vim'

call plug#end()

"===ENDPLUG===
" unite
let g:unite_source_history_yank_enable = 1
let g:unite_source_yank_history_save_clipboard = 1
let g:unite_source_rec_async_command = ['ag', '--follow', '--nocolor', '--nogroup', '--hidden', '-g', '']
autocmd FileType unite call s:unite_settings()
function! s:unite_settings()
  " Play nice with supertab
  let b:SuperTabDisabled=1
  " Enable navigation with control-j and control-k in insert mode
  imap <buffer> <C-j>   <Plug>(unite_select_next_line)
  imap <buffer> <C-k>   <Plug>(unite_select_previous_line)
endfunction
call unite#custom#profile('default', 'context', {
\   'winheight': 10,
\   'direction': 'botright'
\ })
call unite#custom#profile('files', 'filters', 'sorter_rank')
"\   'direction': 'botright',
"\   'vertical_preview': 1,
"call unite#filters#matcher_default#use(['matcher_fuzzy'])
call unite#custom#source('file,file/new,buffer,file_rec',
\ 'matchers', 'matcher_fuzzy')
let g:unite_source_grep_command = 'ag'
"let g:unite_source_grep_default_opts =
"\ '--nogroup --nocolor --column ' .
"\ '''.hg'' --ignore ''.svn'' --ignore ''.git'' --ignore ''.bzr'''
let g:unite_source_grep_default_opts =
\ '-i --vimgrep --hidden --ignore ' .
\ '''.hg'' --ignore ''.svn'' --ignore ''.git'' --ignore ''.bzr'''
let g:unite_source_grep_recursive_opt = ''
let g:unite_enable_start_insert=0
let g:unite_enable_ignore_case = 1
let g:unite_enable_smart_case = 1
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""



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
    \ 'file':'__init__.py'
    \ }

nnoremap <c-p>m :<c-u>CtrlPMRUFiles<cr>
nnoremap <c-p>b :<c-u>CtrlPBuffer<cr>
nnoremap <c-p>. :<c-u>CtrlP .<cr>
nnoremap <c-p>h :<c-u>CtrlP ~/<cr>
nnoremap <c-p>p :<c-u>CtrlP ~/python/<cr>
nnoremap <c-p>w :<c-u>CtrlP $WORKSPACE<cr>
nnoremap <c-p>d :<c-u>CtrlP ~/dotfiles<cr>
nnoremap <c-p>v :<c-u>CtrlP ~/dotfiles/vim.dotlink<cr>
nnoremap <c-p> :<c-u>CtrlP<cr>

" fugitive
command! -nargs=+ GCommit Gcommit -m<q-args>
command! -nargs=+ Gwc Gwrite <bar> Gcommit -m<q-args> <bar> edit
command! -nargs=* GDiff only | Gdiff <args>

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
let g:NERDTreeIgnore=['\~$', '__pycache__', '__init__.py']



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

" syntastic
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*
"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
"let g:syntastic_check_on_open = 1
"let g:syntastic_check_on_wq = 0


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

" flake8
let g:flake8_show_in_gutter=1


" neoterm
let g:neoterm_position='vertical'
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
command! -bang -nargs=1 Hll  :call quickhl#manual#add("^.*" . <q-args> . ".*$", <bang>1)
command! -bang -nargs=* Hlld  :call quickhl#manual#del(map(<q-args>, '"^.*" . v:val . ".*$"'), <bang>1)
command! -bang -nargs=1 Hl   :call quickhl#manual#add(<q-args>, <bang>1)
command! -bang -nargs=* Hld  :call quickhl#manual#del(<q-args>, <bang>1)

"nmap <Space>j <Plug>(quickhl-cword-toggle)
"nmap <Space>] <Plug>(quickhl-tag-toggle)
map <a-m> <Plug>(operator-quickhl-manual-this-motion)


let g:extra_whitespace_ignored_filetypes = ['unite']
let g:no_strip_whitespace = ['markdown']
autocmd BufWritePre * if index(g:no_strip_whitespace, &ft) < 0 | FixWhitespace

"======startify
let g:startify_session_dir = '~/.vim/session'
let g:startify_list_order = ['sessions', 'dir', 'bookmarks', 'files', 'commands']
let g:startify_skiplist = [
    \ '.git/*',
    \ ]
let g:startify_enable_special      = 0
let g:startify_files_number        = 20
let g:startify_relative_path       = 1
let g:startify_change_to_dir       = 0
let g:startify_update_oldfiles     = 1
let g:startify_session_autoload    = 1
let g:startify_session_persistence = 1

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
let delimitMate_excluded_regions = "Comment,String"


"=======nvim-ipy
let g:nvim_ipy_perform_mappings = 0
nnoremap <Plug>(IPyRun) :<c-u>call IPyRun(join(getline(line('.'), line('.') + v:count1 - 1), "\n"))<cr>
vnoremap <Plug>(IPyRun) :<c-u>call IPyRun(join(getline(line("'<"), line("'>")), "\n"))<cr>
" with bang, it is silent
command! -range -bang IPyRun call IPyRun(join(getline(<line1>, <line2>), "\n"), <bang>0)
command! -nargs=+ -bang IPyExe call IPyRun(<q-args>, <bang>0)
command! -nargs=+ -bang I call IPyRun(<q-args>, <bang>0)
command! IPyExit call IPyTerminate()
nmap <a-.> <Plug>(IPy-Interrupt)
imap <silent> <C-F> <Plug>(IPy-Complete)
map <silent> <leader>? <Plug>(IPy-WordObjInfo)

" dbext
let g:dbext_default_profile_pgsql = 'type=PGSQL'
let g:dbext_default_profile = 'pgsql'
let g:dbext_default_use_sep_result_buffer = 1

" surround
imap ;ys <esc>lys
imap ;yss <esc>lyss
imap ;yS <esc>lyS
imap ;ySS <esc>lySS
