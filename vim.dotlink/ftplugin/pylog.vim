function! s:Next(pattern, previous, count) abort
    let pattern = '^\[20.*: ' . a:pattern . '@@'
    let flag = a:previous? 'b' : ''
    let current = line('.')
    for x in range(a:count)
        call search(pattern, flag)
    endfor
endfunction
command! -buffer -nargs=1 -count=1 -bang -bar FindNext call s:Next(<q-args>, <bang>0, <count>)
let b:enhanced_diff_ignore_pat = [['\[.*\]', 'PYLOG_DIFF_IGNORE']]

nmap <buffer> ]e :<c-u>call <SID>Next('4[0-9]', 0, v:count1)<cr>
nmap <buffer> [e :<c-u>call <SID>Next('4[0-9]', 1, v:count1)<cr>

nmap <buffer> ]w :<c-u>call <SID>Next('3[0-9]', 0, v:count1)<cr>
nmap <buffer> [w :<c-u>call <SID>Next('3[0-9]', 1, v:count1)<cr>

nmap <buffer> ]c :call <SID>Next('5[0-9]', 0, v:count1)<cr>
nmap <buffer> [c :call <SID>Next('5[0-9]', 1, v:count1)<cr>

nmap <buffer> ]d :call <SID>Next('1[0-9]', 0, v:count1)<cr>
nmap <buffer> [d :call <SID>Next('1[0-9]', 1, v:count1)<cr>

nmap <buffer> ]2 :call <SID>Next('22', 0, v:count1)<cr>
nmap <buffer> [2 :call <SID>Next('22', 1, v:count1)<cr>

nmap <buffer> ]5 :call <SID>Next('25', 0, v:count1)<cr>
nmap <buffer> [5 :call <SID>Next('25', 1, v:count1)<cr>

nmap <buffer> ]7 :call <SID>Next('27', 0, v:count1)<cr>
nmap <buffer> [7 :call <SID>Next('27', 1, v:count1)<cr>

nmap <buffer> ]0 :call <SID>Next('20', 0, v:count1)<cr>
nmap <buffer> [0 :call <SID>Next('20', 1, v:count1)<cr>

nmap <buffer> ]i :call <SID>Next('2[0-9]', 0, v:count1)<cr>
nmap <buffer> [i :call <SID>Next('2[0-9]', 1, v:count1)<cr>

nmap <buffer> ]] :call <SID>Next('[0-5][0-9]', 0, v:count1)<cr>
nmap <buffer> [[ :call <SID>Next('[0-5][0-9]', 1, v:count1)<cr>

nmap <buffer> ]k :call search('^\[[12][90].*: 30@@.*key=\n\[')<cr>
nmap <buffer> [k :call search('^\[[12][90].*: 30@@.*key=\n\[', 'b')<cr>

