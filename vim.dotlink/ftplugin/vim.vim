
for d in split(&runtimepath, ',')
    exec 'setlocal tags+=' . d . '/doc/tags'
endfor

" with bang,
" if in autoload, switch to ftplugin always. Otherwise, switch to ftplugin if it
" exists
" if in ftplugin or plugin, then switch to autoloasd
command! -buf -bang -nargs=? TogglePlug call buffer#TogglePlug(<q-args>, <bang>0)
nmap <buffer> g# :<c-u>TogglePlug<cr>

set iskeyword+=:
