

"autocmd BufEnter * silent! lcd %:p:h
"
"set shellcmdflag=-ic
"set termguicolors

"set updatetime=4000
set title
set shortmess+=c
set virtualedit=block
"set tildeop  " ~ behaves like an operator
set timeoutlen=400
set clipboard=unnamedplus,unnamed
set hidden
set autoindent cindent
"set smartindent
set hlsearch
set noincsearch
set diffopt+=vertical
set scrollback=10000
set expandtab tabstop=4 softtabstop=4 shiftwidth=4
set keymodel=startsel,stopsel
set backspace=indent,eol,start
set dictionary+=/usr/share/dict/words
"set relativenumber
set number ruler mouse=a
set showcmd noshowmode
set autowrite
set autowriteall
set whichwrap=b,s,<,>,[,]  " use <Left><Right> to move to previous/next line
set completeopt=menuone,longest,preview
set laststatus=2
set wildmode=longest:full,full
set wildmenu
set showtabline=2
" this also affects which window is held no expansion when close window
"set splitright
"set autochdir
set noea
"set cursorline
set switchbuf+=useopen
set cmdheight=2
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
" commandline select folder and complete next level
cnoremap <c-s> /<bs><tab><tab>

nnoremap <F2> :<C-U>NERDTreeTabsToggle<CR>
nnoremap <F3> :<C-U>w<cr>:so%<cr>
"nnoremap <F4> :<C-U>BD<CR>
"nnoremap <F5> :<C-U>AsyncRun<Space>
map <F9> <leader>c<Space>
imap <F9> <C-O><leader>c<Space>

noremap <C-S> :w<CR>
imap <C-S> <Esc><C-S>
noremap <leader>mks :SSave!
nmap Y y$

let tempdir=fnamemodify(tempname(), ':h')

function! ExeLines() range
  let tmp = SaveRegister("#")
  try
    let file = tempname()
    exe ("silent " . a:firstline . "," . a:lastline . "write " . file)
    exe 'so'  file
    call delete(file)
  finally
    call RestoreRegister("#", tmp)
  endtry
endfunction
nnoremap <leader>e :call ExeLines()<CR>
vnoremap <leader>e :call ExeLines()<CR>
function! ExeReg(reg)
  exec substitute(eval("@".a:reg), "\n", "", "")
endfunction
command! -register ExeReg :<c-u>call ExeReg(<q-reg>)<cr>

""""""""""""""""""""""
" command -range=-1 and default to the current line, pass MagicRange(<count>)
" as argument
function! MagicRange(count)
  return a:count ==-1? line('.') : a:count
endfunction
command! -narg=+ -range=-1 Redir call append(MagicRange(<count>), split(execute(<q-args>), "\n"))

function! TestOp() range
  echo a:firstline
  echo a:lastline
  echo 'good222'
  echo 'bad'
endfunction

function! GetMotionRange(type)
  if a:type=='line'
    return "'[V']"
  elseif a:type=='char'
    return "`[v`]"
  else
    return "`[\<C-V>`]"
  endif
endfunction

" detect git folder
nmap <leader>gt :<C-U>silent call fugitive#detect(resolve(expand('%:h')))<CR>
" cd to folder containing current dir

noremap <space>- :<C-u>set invcursorline<cr>
noremap <space><bar> :<C-u>set invcursorcolumn<cr>
noremap g<bar> :<C-u>set invrelativenumber<CR>


function! g:IFuncWrapper(Func, key)
  let F=function(a:Func)
  call F()
  return a:key
endfunction
inoremap <buffer> <expr> <A-;> g:IFuncWrapper('jedi#show_call_signatures', "")

"cWORD
cnoremap <C-R><C-E> <C-R>=expand('<cWORD>')<CR>
"cword
cnoremap <C-R><C-W> <C-R>=expand('<cword>')<CR>
"full name
cnoremap <C-R><C-F> <C-R>=expand('%:p')<cr>
"full directory name
cnoremap <C-R><C-D> <C-R>=expand('%:p:h') . '/'<cr>
"full name for autoload
cnoremap <C-R><C-L> <C-R>=substitute(expand('%:p:h'), 'plugin$', 'autoload', '') . '/'<cr>
"cwd
"cnoremap <C-R><C-C> <C-R>=getcwd()<cr>
cnoremap <C-R><C-J> <C-R>=getcwd()<cr>
function! g:InputBufName()
  let n = str2nr(input('bufnr: '))
  return n==0? '' : bufname(n)
endfunction
"buf name
cnoremap <C-R><C-B> <C-R>=InputBufName()<cr>
"full buf name
cnoremap <C-R><C-N> <C-R>=fnamemodify(InputBufName(), ':p')<cr>

nnoremap <A-/> :<C-U>noh<CR>:redraw<CR>
nnoremap <Space>/ :<C-U>set invhlsearch<CR>

cabbr RR AsyncRun
command! -nargs=+ R new term://<args>

noremap g<cr> :<c-u>normal i<c-v><cr><cr>

cnoreabbr <expr> W ((getcmdtype() is# ':' && getcmdline() is# 'W')?('w'):('W'))
cnoreabbr <> '<,'>
inoremap ,, <end>,
imap ,) <esc>lys$)

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

command! DoFileType doautocmd FileType
command! Doft doautocmd FileType

function! s:ftplugin_location(system)
  return (a:system? expand("$VIMRUNTIME") : "~/.vim") . "/ftplugin/" . &filetype . ".vim"
endfunction
command! -bang EditFtPlug <mods> exec (<q-mods> . " new " . s:ftplugin_location(<bang>0))

function! SaveRegister(reg)
  " if a:reg == "=", the second parameter 1 will make the function return the
  " express instead of the number
  return [getreg(a:reg, 1), getregtype(a:reg)]
endfunction
function! RestoreRegister(reg, values)
  call setreg(a:reg, a:values[0], a:values[1])
endfunction
function! CopyRegister(regfrom, regto)
  call setreg(a:regto, getreg(a:regfrom, 1), getregtype(a:regfrom))
endfunction
command! -nargs=* RegCopy call CopyRegister(<f-args>)

" show syntax group
map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> under transparent<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> linked to <"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>
