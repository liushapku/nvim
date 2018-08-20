"augroup TabWrap
"    au!  InsertEnter,CursorMovedI,CompleteDone * let g:deoplete_tab_called = 0
"augroup END



function! complete#STabWrap() abort
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

function! complete#BSWrap()
    if pumvisible()
        return "\<c-h>"
    else
        return "\<plug>delimitMateBS"
        "\<c-r>=delimitMate#BS()\<cr>"
    endif
endfunction

function! complete#CRWrap() abort
    return pumvisible()? "\<c-y>\<cr>": "\<cr>"
endfunction

function! complete#TabWrap(verbose) abort
  let prefix = strpart( getline('.'), 0, col('.') - 1 )
  if pumvisible()
    if a:verbose | echo 'TabWrap: pumvisible' | endif
    return "\<C-N>"
  elseif prefix == '' || prefix =~ '\s\+$'
    if a:verbose | echo 'TabWrap: empty string' | endif
    return "\<tab>"
  elseif b:deoplete_tab_called == 0
    if a:verbose | echo 'TabWrap: deoplete' | endif
    let result=deoplete#mappings#manual_complete()
    let b:deoplete_tab_called = 1
    return result
  elseif &filetype == 'python'
    if a:verbose | echo 'TabWrap: jedi' | endif
    let b:deoplete_tab_called = 0
    return jedi#complete_string(0)
  elseif &omnifunc != ''
    if a:verbose | echo 'TabWrap: omnifunc' | endif
    return "\<C-X>\<C-O>"
  else
    return "\<tab>"
  endif
endfunction

augroup DeopleteTabWrap
  au!
  au InsertEnter,CursorMovedI,CompleteDone <buffer> let b:deoplete_tab_called = 0
augroup END
