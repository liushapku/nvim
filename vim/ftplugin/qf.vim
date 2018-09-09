
"nmap <buffer> <CR> :silent exec 'cc ' . line('.')<CR>
nnoremap <buffer> q :<c-u>q<cr>
nnoremap <buffer> <silent> yy :call <SID>CopyQuickfix()<cr>
stopinsert
