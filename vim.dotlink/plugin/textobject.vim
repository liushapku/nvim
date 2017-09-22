"======indentwise
function! IndentBlock(prefix)
    if a:prefix == 'a'
        normal [-Vj]&k
    else
        normal [&V]&
    endif
endfunction
function! UnderscoreBlock(prefix)
    let c = col('.')-1
    if getline('.')[c] != '_' && c != 0
        normal ?\(^\|_\|\s\)
        if getline('.')[col('.')-1] =~ '\(_\|\s\)'
            normal l
        endif
    elseif c !=0
        normal l
    endif
    echo a:prefix
    normal v/\(_\|\W\|$\)/e
    if getline('.')[col('.')-1] != '_' || a:prefix == 'i'
        normal h
    endif
endfunction
map [& <Plug>(IndentWiseBlockScopeBoundaryBegin)
map ]& <Plug>(IndentWiseBlockScopeBoundaryEnd)
vmap ii :<c-u>call IndentBlock('i')<cr>
vmap ai :<c-u>call IndentBlock('a')<cr>
omap ii :normal Vii<cr>
omap ai :normal Vai<cr>
vmap i_ :<c-u>call UnderscoreBlock('i')<cr>
vmap a_ :<c-u>call UnderscoreBlock('a')<cr>
omap i_ :normal vi_<cr>
omap a_ :normal va_<cr>



function! DotBlock(prefix)
    let c = col('.')-1
    if getline('.')[c] != '.' && c!=0
        normal ?\(^\|\.\|\s\)
        if getline('.')[col('.')-1] =~ '\(\.\|\s\)'
            normal l
        endif
    elseif c != 0
        normal l
    endif
    normal v/\(\.\|\s\|$\)/e
    if getline('.')[col('.')-1] != '.' || a:prefix == 'i'
        normal h
    endif
endfunction
vmap i. :<c-u>call DotBlock('i')<cr>
vmap a. :<c-u>call DotBlock('a')<cr>
omap i. :normal vi.<cr>
omap a. :normal va.<cr>
