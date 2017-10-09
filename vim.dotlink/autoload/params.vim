function! params#Echo()
    for doc in b:echodoc
      if has_key(doc, 'highlight')
        execute 'echohl' doc.highlight
        echon doc.text
        echohl None
      else
        echon doc.text
      endif
    endfor
endfunction

function! params#GetParams()
    if !exists('b:echodoc')
        return ''
    endif

    let params = []
    let ident = ''
    let started = 0
    for doc in b:echodoc
        if get(doc, 'highlight', '') == 'Identifier'
            let ident = doc.text
            continue
        endif
        if doc.text is '('
            let started = 1
            continue
        elseif doc.text is ')'
            let started = 0
            continue
        elseif doc.text is ', '
            continue
        elseif started
            call add(params, doc.text)
        endif
    endfor
    return [ident, params]
endfunction

function! params#Complete(jump) abort
    let [ident, params] = params#GetParams()
    return join(params, ', ') . ')' . (a:jump? "\<esc>%":"")
endfunction

function! params#SelectNext()
    silent normal! vi,
endfunction

function! params#GotoNextPara() abort
    let found= search('[(,]', 'c')
    if found
        call search('\S', '')
    endif
endfunction
function! params#GotoPrevPara() abort
    let found= search('[,)]', 'bc')
    if found
        call search('[(,]\s*\S', 'be')
    endif
endfunction

function! params#SelectNextPara() abort
    if getline('.')[col('.')-1:] !~ '^[(,]'
        silent normal! /[(,]
    endif
    silent normal! /\S
    exec 'silent normal! v/\([^,(]*([^()]*)[^,)]*\)*\zs[,)]/e-1' . "\<cr>\<c-g>"

    return ""
endfunction

function! params#SelectNextEqual() abort
    let saved_pattern = @/
    let saved_hi = &l:hlsearch
    setlocal nohlsearch
    if getline('.')[col('.')-1] !~ '^[=]'
        silent normal! /[=),]
    endif
    let nextchar = getline('.')[col('.')-1]
    if nextchar == ',' || nextchar == ')'
        startinsert
    else
        silent normal! l
        if getline('.')[col('.')-1] == ','
            startinsert
        else
            silent exec "normal v],h\<c-g>"
        endif
    endif
    let &l:hlsearch = saved_hi
    let @/ = saved_pattern
endfunction

function! params#SelectPrevPara() abort
    if getline('.')[col('.')-1:] !~ '^[),]'
        silent normal! ?[),]
    endif
    silent normal ?[(,]?;/\S/
    exec "silent normal! v/[,)]/e\<cr>h\<c-g>"
    return ""
endfunction

function! params#SelectPrevEqual() abort
    if getline('.')[col('.')-1:] !~ '^[),]'
        silent normal! ?,?
    endif
    silent normal! ?[=,]?
    call SelectNextEqual()
endfunction
