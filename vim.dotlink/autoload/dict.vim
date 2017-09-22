function! dict#StringToDict(dic, reverse) abort
    " \@! negative look forward
    let result = {}
    for r in a:dic
        if r !~ "="
            continue
        endif
        if a:reverse
            let [val, key] = split(r, "=")
        else
            let [key, val] = split(r, "=")
        endif
        let key = string#Strip(key)
        let val = string#Strip(val)
        let result[key] = val
    endfor
    return result
endfunction

function! dict#GetLines(line1, line2, reg, force, reverse) abort
    let dic=dict#StringToDict(getline(a:line1, a:line2), a:reverse)
    if exists('g:my_replace_dic')
        let method = a:force ? 'force' : 'keep'
        call extend(g:my_replace_dic, dic, method)
    else
        let g:my_replace_dic = dic
    endif
    exe a:line1 . "," . a:line2 . "delete " . a:reg
endfunction

function! dict#Get(motion_wise) abort
    " all are linewise
    let line1 = line("'[")
    let line2 = line("']")
    call dict#GetLines(line1, line2, "", 0, 0)
endfunction

function! dict#GET(motion_wise) abort
    " all are linewise
    let line1 = line("'[")
    let line2 = line("']")
    call dict#GetLines(line1, line2, "", 0, 1)
endfunction

function! dict#Replace(motion_wiseness) abort
    " all are characterwise
    let temp=@t
    silent normal! `[v`]"ty
    let text = get(g:my_replace_dic, string#Strip(@t))
    if text isnot 0
        echo text
        silent normal gv"=textp
    endif
    let @t=temp
endfunction

function! dict#ReverseKVLines(line1, line2) abort
    for l in range(a:line1, a:line2)
        let s = substitute(getline(l), '\s\*$', '', '')
        if match(s, ',\s*$' ) == -1
            let s = s . ','
        endif
        if match(s, '\s*[^:]\+\s*:\s*\S\+\s*,$') == -1
            echoerr 'didnot match a dict item at line: ' . l
        endif
        let s = substitute(s, '\(\s*\)\([^: \t]\+\)\(\s*\):\(\s*\)\(\S\+\)\(\s*\),$', '\1\5 :\4\2,', '')
        call setline(l, s)
    endfor
endfunction

function! dict#Reverse(motionwise) abort
    let line1 = line("'[")
    let line2 = line("']")
    call dict#ReverseKVLines(line1, line2)
endfunction
