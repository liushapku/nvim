
function! autocmd#BufWinLeave()
    if &diff
        diffoff!
    endif
endfunction

function! autocmd#BufWinEnter()
    if &ft == 'csv' && b:delimiter == "\t"
        setlocal conceallevel=0
    else
        setlocal conceallevel=2
    endif
endfunction

function! autocmd#WinEnter()
    if &buftype == 'quickfix'
        stopinsert
    endif
endfunction

function! autocmd#BufEnter()
    call buffer#AutoRestoreWinView()
    if &buftype == 'quickfix'
    endif

    if &buftype == 'help'
        nnoremap <buffer> q :<c-u>q<cr>
        stopinsert
    elseif &buftype == 'terminal'
        if expand('%') =~ 'neoterm-[0-9]\+$'
            let g:current_neoterm = substitute(expand('%'), '.*neoterm-\([0-9]\)\+$', '\1', 0)
            set ft=neoterm
        endif
    endif


    if bufname('%') =~ '\.input\(.[0-9]\+\)\?'
        "set filetype=sh
    elseif bufname('%') =~ '\.git/COMMIT_EDITMSG' || bufname('%') =~ 'ipython_edit.*py'
        setlocal bufhidden=delete
    endif
endfunction

function! autocmd#BufLeave()
    call buffer#AutoSaveWinView()
    "if index(['python'], &filetype) > -1
    "    silent! write
    "endif
endfunction

function! autocmd#TBufDelete()
    let this= substitute(expand("<afile>"), '.*neoterm-\([0-9]\+\)$', '\1', '')
    if this != g:current_neoterm
        return
    endif
    let next_buf_term = buffer#NextNeoterm(g:current_neoterm)
    if next_buf_term == g:current_neoterm
        unlet g:current_neoterm
    else
        let g:current_neoterm = next_buf_term
    endif
endfunction

function! autocmd#TermOpen()
    if !exists('g:current_neoterm')
        let g:current_neoterm = 1
    endif
endfunction

function! autocmd#WinLeave()
endfunction

function! autocmd#FileOpen()
    if bufname('%') =~ 'JP.*\.20[0-9]\{6\}'
        echo bufname('%')
        setfiletype csv
    endif
endfunction
