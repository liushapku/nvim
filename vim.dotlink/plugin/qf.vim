
"errorformat=%C %.%#,%A  File "%f"\, line %l%.%#,%Z%[%^ ]%\@=%m
"set efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m
"let g:python_traceback_format0='%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m'
let g:python_traceback_format0=join([
    \ '%A  File "%f"\, line %l\, %m',
    \ '%A  File "%f"\, line %l',
    \ "%Z%p^",
    \ "%Z    %m",
    \ ], ',')
let g:python_traceback_format2=join([
    \ '%A %#  File "%f"\, line %l\, %m',
    \ '%A %#  File "%f"\, line %l',
    \ "%Z%p^",
    \ "%Z %#    %m",
    \ ], ',')
" for result from ctest
let g:python_traceback_format1=join([
    \ '%A%\d%\+:  %#  File "%f"\, line %l\, %m',
    \ '%A%\d%\+:  %#  File "%f"\, line %l',
    \ '%Z%\d%\+: %p^',
    \ '%Z%\d%\+:  %#    %m',
    \ ], ',')
let g:python_traceback_format_ipython=join([
    \ '%A[FILE]:%f %m',
    \ '%C %\+%\d%\+%.%#',
    \ '%C-%\+> %l %m',
    \ '%A%^%$'
    \ ], ',')

let g:python_traceback_format=join([g:python_traceback_format2, g:python_traceback_format1], ',')

function! WriteVariable(data, file)
    call writefile(split(a:data, "\n", 1), a:file)
endfunction

function! SetQF(data, ...)
    let opts = a:0 == 0? {} : a:1
    let tempfile = Tempname()
    let data = a:data
    let strs = filter(split(data, "\n", 1), 'v:val != ""')
    call writefile(strs, tempfile)
    let position = get(opts, 'location', 'quickfix')
    let cmd = position == 'quickfix' ? 'cg ' : 'lg '
    let oldefm = &efm
    let &efm = get(opts, 'efm', &efm)
    exec cmd . tempfile
    let &efm = oldefm
endfunction

function! GetQF(type) abort
    let switch=buffer#SwitchToBuffer('neoterm-' . g:current_neoterm)
    let temp = @"
    normal G
    silent normal :?Traceback?+1;/^\(\d\+: \)\?\s*\S\+Error/y "
    call buffer#SwitchBack(switch)
    if a:type == 'ipython'
        let msg = substitute(@", "\n\n", "\n\n[FILE]:", "g")
        let msg = "[FILE]:" . msg
        let efm = g:python_traceback_format_ipython
    elseif a:type == 'python'
        let msg = string#SearchAndSubstitute(@", '\(\d\+: \)\?  File .*, line \d\+, in \w\+', "$", '():', '')
        let efm = g:python_traceback_format
    else
        let msg = @"
        let efm = &efm
    endif
    call SetQF(msg, {'efm': efm})
    let @"=temp
    bo cw
endfunction

"vmap ;qf y:call SetQF(@@)<cr>
vnoremap ;qf ""y:call SetQF(@", {})<cr>:bo cw<cr>
nnoremap ;qf :<c-u>?Traceback?+1;/^\(\d\+: \)\?\w\+Error/y "<cr>:call SetQF(@", {'efm': g:python_traceback_format})<cr>:Qw<cr>
command! CQF :setqflist([]) | cw
command! QF call GetQF('python')
command! QFi call GetQF('ipython')
command! RQF call setqflist(reverse(getqflist()))
command! -register SQF call SetQF(@<reg>)
