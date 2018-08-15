
"=====deoplete
"=====jedi
let g:deoplete#enable_at_startup = 1
let g:deoplete#auto_complete_start_length = 3
"let g:deoplete#sources#jedi#show_docstring = 1
let g:deoplete#sources#jedi#python_path=g:python3_path
let g:deoplete#sources = {}
let g:deoplete_mysources = ['ultisnips', 'file']
let g:deoplete#sources._ = ['buffer', 'around', 'tag', 'dictionary'] + g:deoplete_mysources
let g:deoplete#sources.python = ['jedi'] + g:deoplete_mysources
let g:deoplete#auto_complete_delay = 50
let g:deoplete#auto_refresh_delay = 100
"let g:deoplete#disable_auto_complete = 1
call deoplete#custom#source('ultisnips', 'rank', 9999)
call deoplete#custom#source('_', 'matchers', ['matcher_head'])

let g:deoplete#ignore_sources = {}
let g:deoplete#ignore_sources.python = ['member', 'buffer', 'tag']
"call deoplete#custom#set('ultisnips', 'min_pattern_length', 2)
"call deoplete#custom#set('ultisnips', 'max_pattern_length', 2)
""use <tab> for completion
let g:deopelte_tab_called = 0
function! TabWrap() abort
    let prefix = strpart( getline('.'), 0, col('.') - 1 )
    if pumvisible()
        echo 'TabWrap: pumvisible'
        return "\<C-N>"
    elseif prefix == '' || prefix =~ '\s\+$'
        echo 'TabWrap: empty string'
        return "\<tab>"
    elseif exists('g:loaded_deoplete') && g:loaded_deoplete == 1 && &filetype != 'vim'
        echo 'TabWrap: deoplete'
        "let g:deoplete_tab_called = 1
        let result=deoplete#mappings#manual_complete()
        return result
    elseif &omnifunc != ''
        echo 'TabWrap: omnifunc'
        return "\<C-X>\<C-O>"
    else
        "echo 'TabWrap: nothing' g:deoplete_tab_called
        return "\<tab>"
    endif
endfunction

"augroup TabWrap
"    au!  InsertEnter,CursorMovedI,CompleteDone * let g:deoplete_tab_called = 0
"augroup END

function! STabWrap() abort
    if pumvisible()
        return "\<C-P>"
    let line = getline('.')
    let cl = col('.')
    if getline('.')[col('.')-1] =~ "[({\[<'\"]"
        return "\<Plug>delimitMateS-Tab"
    elseif &omnifunc != ''
        return "\<C-X>\<C-O>"
    else
        return "\<C-Space>"
endfunction

function! BSWrap()
    if pumvisible()
        return "\<c-h>"
    else
        return "\<plug>delimitMateBS"
        "\<c-r>=delimitMate#BS()\<cr>"
    endif
endfunction
function! CRWrap() abort
    return pumvisible()? "\<c-y>\<cr>": "\<cr>"
endfunction

imap <expr><a-\>  deoplete#toggle()?'':''
nmap <a-\> :<c-u>call deoplete#toggle()<cr>

" power tab
inoremap <silent><expr> <C-G> deoplete#undo_completion()
inoremap <silent><expr><tab> TabWrap()
"imap <silent><expr><s-tab> STabWrap()
imap <silent><expr> <BS> BSWrap()
inoremap <silent><expr> <Esc> pumvisible() ? "<C-y><Esc>" : "<Esc>"
"inoremap <silent><expr> <cr> CRWrap()
"inoremap <expr> <ESC> pumvisible()? "\<C-E>" : "\<ESC>"
inoremap <expr> <Down> pumvisible()? "\<C-E>\<Down>":"\<Down>"
inoremap <expr> <Up> pumvisible()? "\<C-E>\<Up>":"\<Up>"

let g:echodoc_enable_at_startup = 1
let g:UltiSnipsExpandTrigger=";;"
inoremap ;2 ;;
let g:UltiSnipsListSnippets="<c-l>"
let g:UltiSnipsJumpForwardTrigger="<c-n>"
let g:UltiSnipsJumpBackwardTrigger="<c-p>"
let g:UltiSnipsEditSplit="normal"
let g:UltiSnipsSnippetDirectories=['UltiSnips']
let g:UltiSnipsSnippetsDir="~/.vim/UltiSnips"


"" Enter: complete&close popup if visible (so next Enter works); else: break undo
"" Ctrl-Space: summon FULL (synced) autocompletion
"inoremap <silent><expr> <C-Space> deoplete#mappings#manual_complete()
"" Escape: exit autocompletion, go to Normal mode
"let g:jedi#completions_command="\<C-L>"
let g:jedi#show_call_signatures=0
let g:jedi#popup_select_first=1
let g:jedi#popup_on_dot=0
let g:jedi#show_call_signatures_delay=200

