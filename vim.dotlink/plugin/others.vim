"buffer map: @


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
set sessionoptions-=curdir
set sessionoptions+=sesdir
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
if has('nvim')
  set undofile
endif

filetype plugin indent on

nnoremap <F2> :<C-U>NERDTreeTabsToggle<CR>
nnoremap <F3> :<C-U>w<cr>:so%<cr>
"nnoremap <F4> :<C-U>BD<CR>
"nnoremap <F5> :<C-U>AsyncRun<Space>
map <F9> <leader>c<Space>
imap <F9> <C-O><leader>c<Space>

noremap <C-S> :w<CR>
imap <C-S> <Esc><C-S>
noremap <leader>mks :mksession!
noremap <leader>info :wviminfo!
noremap <C-F10> :set mouse=


let tempdir=fnamemodify(tempname(), ':h')
nmap Y y$

function! ExeLines()
    let file = tempname()
    exe "'<,'>write " . file
    exe 'so'  file
endfunction
nnoremap <leader>e :exe getline(".")<CR>
vnoremap <leader>e :<C-U>call ExeLines()<CR>
command! -register ExeReg exe getreg(<q-reg>)

""""""""""""""""""""""

function! Redir(command)
    redir! => temp
    silent exec a:command
    redir END
    return temp
endfunction
" command -range=-1 and default to the current line, pass MagicRange(<count>)
" as argument
function! MagicRange(count)
    return a:count ==-1? line('.') : a:count
endfunction

command! -narg=+ -range=-1 Redir call append(MagicRange(<count>), split(Redir(<q-args>), "\n"))

function! TestOp() range
    echo a:firstline
    echo a:lastline
    echo 'good'
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

function! ExecRegister()
    let a=substitute(eval("@".v:register), "\n", "", "")
    exec a
endfunction

nmap <leader>gt :<C-U>silent call fugitive#detect(resolve(expand('%:h')))<CR>
nmap <leader>cd :<C-U>silent exec "lcd " . expand('%:h')<bar>pwd<CR>

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
cnoremap <C-R><C-C> <C-R>=getcwd()<cr>
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

noremap g<cr> :<c-u>normal i<c-v><cr><cr>

cnoreabbr <expr> W ((getcmdtype() is# ':' && getcmdline() is# 'W')?('w'):('W'))
cnoreabbr <> '<,'>


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

command! EditPlugin exe "edit ~/.vim/ftplugin/" . &filetype . ".vim"

command! -complete=command -nargs=+ SubOutput call SubOutput('', <f-args>)
command! -complete=command -nargs=+ FSubOutput call SubOutput(<f-args>)
function! SubOutput(filterpattern, pattern, ...)
  if a:0 == 0
    return
  endif
  let command = join(a:000, ' ')
  let pat = split(a:pattern, a:pattern[0]) + ['', '']
  redir => output
    if a:filterpattern is ''
        silent exe command
    else
        silent exe 'filter ' . a:filterpattern . ' ' . command
    endif
  redir END
  for out in split(output, "\n")
      let p = pat[0] is ''? @/: pat[0]
      let newout = substitute(out, pat[0], pat[1], pat[2])
      echo newout
  endfor
endfunction

command! -complete=file -nargs=* Vnew botright vnew <args>
