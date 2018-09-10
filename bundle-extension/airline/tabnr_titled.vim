" MIT License. Copyright (c) 2017-2018 C.Brabandt et al.
" vim: et ts=2 sts=2 sw=2

scriptencoding utf-8

function! g:TablineTitle(nr)
  let title = gettabvar(a:nr, 'tabline_title')
  if title != ''
    let title = printf('[%s]', title) . (g:airline_symbols.space)
  endif
  return title
endfunction

function! airline#extensions#tabline#formatters#IGNORE_tabnr_titled#format(tab_nr_type, nr)
  let title = printf('%%{g:TablineTitle(%d)}', a:nr)
  if a:tab_nr_type == 0 " nr of splits
    return (g:airline_symbols.space).title.'%{len(tabpagebuflist('.a:nr.'))}'
  elseif a:tab_nr_type == 1 " tab number
    return (g:airline_symbols.space).title.a:nr
  else "== 2 splits and tab number
    return (g:airline_symbols.space).title.a:nr.'.%{len(tabpagebuflist('.a:nr.'))}'
  endif
endfunction
