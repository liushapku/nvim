nmap <buffer> ;d :exe "new" system('which ' . shellescape(expand("<cWORD>")))<cr>
