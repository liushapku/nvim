"
"set shellcmdflag=-ic
"set termguicolors

"set updatetime=4000
"set tildeop  " ~ behaves like an operator
set cedit=
set title
set shortmess+=c
set virtualedit=block
set timeoutlen=400
set clipboard=unnamed
set hidden
set autoindent cindent
"set smartindent
set wildmode=longest:full,full wildmenu
set hlsearch noincsearch
set inccommand=nosplit
set diffopt+=vertical
set scrollback=10000
set keymodel=startsel,stopsel
set backspace=indent,eol,start
set dictionary+=/usr/share/dict/words
"set relativenumber
set number ruler mouse=a
set completeopt=menuone,longest,preview
set showcmd noshowmode
set autowrite autowriteall
set whichwrap=b,s,<,>,[,]  " use <Left><Right> to move to previous/next line
set laststatus=2
set showtabline=2
" this also affects which window is held no expansion when close window
"set splitright
"set autochdir
set equalalways
"set cursorline
set switchbuf+=useopen
set cmdheight=3  " this is for the cmdline
set cmdwinheight=10  " this is for the cmd window (opened using q:)
set nostartofline
set grepprg=ag\ --vimgrep\ $*
set grepformat=%f:%l:%c:%m
set suffixes^=.ipynb
set wildcharm=<tab>
" select folder and complete files inside it
if has('nvim')
  set undofile
endif
filetype plugin indent on
noremap <space>- :<C-u>set invcursorline<cr>
noremap <space><bar> :<C-u>set invcursorcolumn<cr>
noremap g<bar> :<C-u>set invrelativenumber<CR>

" commandline select folder and complete next level
cnoremap <c-s> /<bs><tab><tab>

nnoremap <F2> :<C-U>NERDTreeTabsToggle<CR>
"nnoremap <F5> :<c-u>!xdg-open %<cr>
map <F9> <Plug>NERDCommenterToggle
imap <F9> <C-O><Plug>NERDCommenterToggle
" show syntax group
map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> under transparent<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> linked to <"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>


noremap <c-s> :<c-u>w<cr>
inoremap <c-s> <esc>:w<cr>
noremap <leader>mks :SSave!
nmap Y y$

let tempdir=fnamemodify(tempname(), ':h')
let cachedir=expand('~/.vim/custom/cache')

" detect git folder
" cd to folder containing current dir

cnoremap <C-R>= <C-R>=
"cWORD
cnoremap <C-R><C-E> <C-R>=expand('<cWORD>')<CR>
"cword
cnoremap <C-R><C-W> <C-R>=expand('<cword>')<CR>
"full name
cnoremap <C-R><C-F> <C-R>=expand('%:p')<cr>
"full directory name
cnoremap <C-R><C-D> <C-R>=expand('%:p:h') . '/'<cr>
"cwd
cnoremap <C-R><C-J> <C-R>=getcwd()<cr>
"buf name
cnoremap <C-R><C-B> <C-R>=expand('#'.str2nr(input('bufnr: ')))<cr>
"full buf name
cnoremap <C-R><C-N> <C-R>=expand('#'.str2nr(input('bufnr: ')).':p')<cr>

nnoremap <A-/> :<C-U>noh<CR>:redraw<CR>
nnoremap <Space>/ :<C-U>set invhlsearch<CR>

command! -nargs=+ R new term://<args>

noremap g<cr> :<c-u>normal i<c-v><cr><cr>
nmap <space>c :<c-u>let &conceallevel=(&conceallevel == 0? 2:0)<cr>

function! ToggleFoldMethod()
  if &foldmethod != 'manual'
    set foldmethod=manual
  else
    set foldmethod=indent
  endif
  echo &foldmethod
endfunction
nmap <space>f :<c-u>call ToggleFoldMethod()<cr>

command! -nargs=1 -range=% Count <line1>,<line2>s/<args>//gn


let g:listen_address_file = cachedir . '/NVIM_LISTEN_ADDRESS.txt'
function! s:make_vim_server(off)
  if a:off
    if filereadable(g:listen_address_file)
      call delete(g:listen_address_file)
    endif
  else
    call writefile([$NVIM_LISTEN_ADDRESS], g:listen_address_file)
    autocmd VimLeave * Serve!
  endif
endfunction
command! -bang Serve call s:make_vim_server(<bang>0)


" for markdown
function! s:prepend_space(line1, line2)
  let x = getline(a:line1, a:line2)
  call map(x, 'substitute(v:val, "^", "    ", "g")')
  call setreg('*', x, 'l')
  call setreg('"', x, 'l')
endfunction
command! -range CopyCode :call s:prepend_space(<line1>, <line2>)

command! EShada :<mods> split ~/.local/share/nvim/shada/main.shada

function! s:Shebang(executable)
  if &ft == 'python'
    let shebang = '#!/usr/bin/env python'
  elseif &ft == '' || &ft == 'sh'
    let shebang = '#!/bin/bash'
    set ft=sh
  endif
  0put =shebang
  write
  if a:executable
    Chmod a+x
  endif
endfunction
command! -bar -bang Shebang :call s:Shebang(<bang>1)


command! -range=% -addr=windows Diff :diffoff! | <line1>,<line2>windo diffthis
command! -nargs=1 -complete=dir Lcd :windo lcd <args>

if !exists('g:logdestination')
  let g:logdestination = '/tmp/vim.log'
endif

let g:autoread_timer = 400
function! s:Autoread(stop)
  if a:stop && has_key(b:, 'autoread_timer')
    call timer_stop(b:autoread_timer)
    unlet b:autoread_timer
  elseif !has_key(b:, 'autoread_timer')
    let nr = bufnr("%")
    let b:autoread_timer = timer_start(400,
          \ {id-> execute('checktime ' . nr)},
          \ {'repeat': -1})
  endif
endfunction
command! -bang Autoread call s:Autoread(<bang>0)

function! s:Gsync(bang)
  if !exists("b:git_dir")
    return
  endif
  let repo = matchlist(b:git_dir, ".*" . $HOME . '/\(.*\)/.git')[1]
  let command = ':JobQ --onexit=caddexpr gitall -C ' . repo . ' pull'
  let sep = ["========================================", ""]
  exe "JobQ --onexit='cgetexpr self.chunks' " .
        \ "--onexit+='caddexpr sep' " .
        \ "--onexit+=" . string(command) .
        \ " git push " . (a:bang?'--force':'')
endfunction
command! -bang Gsync  call s:Gsync(<bang>0)
