
for d in split(&runtimepath, ',')
    exec 'setlocal tags+=' . d . '/doc/tags'
endfor

" with bang,
" if in autoload, switch to ftplugin always. Otherwise, switch to ftplugin if it
" exists
" if in ftplugin or plugin, then switch to autoloasd
function! s:toggle_plug(name, ftplugin)
  let fname = len(a:name) == ''? expand('%:p') : a:name
  if fname =~# 'plugin'
    let fname = substitute(fname, 'plugin', 'autoload', '')
  elseif fname =~# 'ftplugin'
    let fname = substitute(fname, 'ftplugin', 'autoload', '')
  elseif fname =~# 'autoload'
    let fname = substitute(fname, 'autoload', 'plugin', '')
    let fname2 = substitute(fname, 'autoload', 'ftplugin', '')
    if (filereadable(fname2) || a:ftplugin)
      let fname = fname2
    endif
  else
    return
  endif
  exe "edit" fname
endfunction


command! -buf -bang -nargs=? TogglePlug call <SID>toggle_plug(<q-args>, <bang>0)
command! -buf -bang -nargs=? EditPlug <mods> vsplit | call <SID>toggle_plug(<q-args>, <bang>0)
nmap <buffer> g# :<c-u>TogglePlug<cr>
nmap <buffer> ;d :<c-u>EditFunction<cr>
nmap <buffer> ;D :<c-u>EditCommand<cr>
vmap <buffer> ;d y:<c-u>EditFunction <c-r>*<cr>
vmap <buffer> ;D y:<c-u>EditCommand <c-r>*<cr>

setlocal iskeyword+=:
nmap <buffer> ;E :<c-u>so %<cr>
