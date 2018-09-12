
function! fzfe#execute(qargs, bang) abort
  let pat = '^\(.\{-}\)\?\(|source!\?\s.\{-}\)\?\(|fzf!\?\s.\{-}\)\?\(|sink[-* ].*\)\?$'
  let [vimoptions, source, fzfoptions, sink] = matchlist(a:qargs, pat)[1:4]
  let wrap = {}
  if !empty(vimoptions)
    let [opts, positional] = scripting#parse({}, vimoptions)
    if !empty(positional)
      throw 'unknown positional args: ' . string(positional)
    endif
    call extend(wrap, opts)
  endif
  let name = scripting#pop(wrap, 'name', 'fzf')
  if !empty(source)
    let [unused, mode, IFS, opts] =
          \ matchlist(source, '^|source\(\([:!]\)\(\S*\)\)\?\s\+\(.\{-}\)\s*$')[1:4]
    if mode == ':'   "Execute code
      let code = scripting#parse({'[POSITIONAL]':'all', '[IFS]':IFS}, opts)[1]
      let wrap['source'] = split(execute(code), "\n")
    elseif mode == '!'  "systemlist
      let code = scripting#parse({'[POSITIONAL]':'all', '[IFS]':IFS}, opts)[1]
      let wrap['source'] = systemlist(code)
    else "run system command
      let wrap['source'] = opts
    endif
  endif
  if !empty(fzfoptions)
    let opts = matchlist(fzfoptions, '^|fzf!\?\s\+\(.\{-}\)\s\+$')[1]
    if fzfoptions =~ '^|fzf!'
      let wrap['options'] = opts
    else
      let wrap['options'] = scripting#parse({'[POSITIONAL]':'all'}, opts)[1]
    endif
  endif

  if !empty(sink)
    try
      let [sep, codes] =
            \ matchlist(sink, '^|sink\(*\S*\|-\S*\)\?\s\+\(.\{-}\)\s*$')[1:2]
    catch
      echo '   invalid sink:' sink
      return
    endtry
    if sep =~ '^\*'
      let sep = sep[1:]
      let star = 1
    else
      let star = 0
      if sep =~ '^-'
        let sep = sep[1:]
      endif
    endif
    let wrap['__codes__'] = sep==''?[codes]:split(codes, sep)
    if star
      function! wrap.sink(lines)
        let lines = a:lines
        for code in self['__codes__']
          exe code
        endfor
      endfunction
      let wrap['sink*'] = remove(wrap, 'sink')
    else
      function! wrap.sink(line)
        let line = a:line
        for code in self['__codes__']
          exe code
        endfor
      endfunction
    endif
  endif
  let wrapped = fzf#wrap(name, wrap, a:bang)
  call fzf#run(wrapped)
endfunction
