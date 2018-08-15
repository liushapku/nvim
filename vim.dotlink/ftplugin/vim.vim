
for d in split(&runtimepath, ',')
    exec 'setlocal tags+=' . d . '/doc/tags'
endfor

command! -buf -nargs=? TogglePlug call buffer#TogglePlug(<q-args>)
command! -buf -nargs=? ToggleFtPlug call buffer#ToggleFtPlug(<q-args>)
nmap <buffer> g# :<c-u>TogglePlug<cr>
