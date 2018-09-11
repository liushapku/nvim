
"=====deoplete
"=====jedi
let g:deoplete#enable_at_startup = 1
set completeopt-=preview
"let g:deoplete#sources#jedi#show_docstring = 1

call deoplete#custom#option('sources', {
      \ '_': ['ultisnips', 'file', 'buffer', 'around', 'tag', 'dictionary'],
      \ 'python': ['ultisnips', 'file', 'jedi'],
      \ })
call deoplete#custom#option('ignore_sources', {
      \ 'vim': ['tag'],
      \ })
call deoplete#custom#option({
      \ 'auto_complete_delay': 50,
      \ 'smart_case': 1,
      \ 'auto_refresh_delay': 100,
      \ 'min_pattern_length': 2
      \ })
call deoplete#custom#source('ultisnips', 'rank', 9999)
call deoplete#custom#source('vim', 'min_pattern_length', 3)
"call deoplete#custom#source('_', 'matchers', ['matcher_head'])


imap <expr><a-\>  deoplete#toggle()?'':''
nmap <a-\> :<c-u>call deoplete#toggle()<cr>

" power tab
inoremap <silent><expr> <C-G> deoplete#undo_completion()
inoremap <silent><expr><tab> complete#TabWrap(0)
imap <silent><expr><s-tab> complete#STabWrap()
imap <silent><expr> <BS> complete#BSWrap()
inoremap <silent><expr> <Esc> pumvisible() ? "<C-y><Esc>" : "<Esc>"
"inoremap <silent><expr> <cr> CRWrap()
"inoremap <expr> <ESC> pumvisible()? "\<C-E>" : "\<ESC>"
inoremap <expr> <Down> pumvisible()? "\<C-E>\<Down>":"\<Down>"
inoremap <expr> <Up> pumvisible()? "\<C-E>\<Up>":"\<Up>"

let g:echodoc_enable_at_startup = 1
let g:UltiSnipsExpandTrigger=";;"
inoremap ;2 ;;
let g:UltiSnipsListSnippets="<c-l>"
"let g:UltiSnipsJumpForwardTrigger="<c-n>"
"let g:UltiSnipsJumpBackwardTrigger="<c-p>"
let g:UltiSnipsJumpForwardTrigger=";n"
let g:UltiSnipsJumpBackwardTrigger=";p"
let g:UltiSnipsEditSplit="normal"
let g:UltiSnipsSnippetDirectories=['UltiSnips']
let g:UltiSnipsSnippetsDir="~/.vim/UltiSnips"
command! Snip UltiSnipsEdit


"" Enter: complete&close popup if visible (so next Enter works); else: break undo
"" Ctrl-Space: summon FULL (synced) autocompletion
"inoremap <silent><expr> <C-Space> deoplete#mappings#manual_complete()
"" Escape: exit autocompletion, go to Normal mode
"let g:jedi#completions_command="\<C-L>"
"let g:jedi#auto_initialization = 0
let g:jedi#max_doc_height=20
let g:jedi#auto_vim_configuration=0
let g:jedi#show_call_signatures=0
let g:jedi#popup_select_first=1
let g:jedi#popup_on_dot=0
let g:jedi#show_call_signatures_delay=200

augroup CompleteAu
  autocmd!
  autocmd BufWinEnter '__doc__' setlocal bufhidden=delete
augroup END
