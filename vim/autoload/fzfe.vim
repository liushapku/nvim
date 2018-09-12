
function! fzfe#execute(qargs, bang)
  let [options, source] = matchlist(a:qargs, '\(.*\)\s--\s\(.*\)')[1:2]
  let [options, positional] = scripting#parse({'[AUTOPOSITIONAL]': 1}, options)
  let vimoptions = {}
  let vimoptions['source'] = source
  if has_key(options, 'dir')
    let vimoptions['dir'] = remove(options, 'dir')
  endif
  let name = scripting#pop(options, 'name', 'fzf')
  let shelloptions = []
  for key in keys(options)
    call add(shelloptions, '--' . key)
    if options[key] != '1DEFAULT'
      call add(shelloptions, options[key])
    endif
  endfor
  let vimoptions['options'] = shelloptions
  let vimoptions['__code__'] = positional

  if !empty(positional)
    if positional[0][0] == '*'
      let star = 1
      positional[0][0] = positonal[0][1:]
    else
      let star = 0
    endif
    if star
      function vimoptions.sink(lines)
        let lines = a:lines
        for code in self.__code__
          exe code
        endfor
      endfunction
      let vimoptions['sink*'] = remove(vimoptions, 'sink')
    else
      function vimoptions.sink(line)
        let line = a:line
        for code in self.__code__
          try
            let code = printf(code, line)
          catch
          endtry
          exe code
        endfor
      endfunction
    endif
  endif
  let wrapped = fzf#wrap(name, vimoptions, a:bang)
  Log! name . string(vimoptions) . a:bang
  Log! wrapped
  call fzf#run(wrapped)
endfunction
