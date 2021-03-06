function! scripting#locate_command(command) abort
  let acommand = a:command == ''? expand("<cword>") : a:command
  let output = execute('verb comm ' . acommand)
  let ret = split(output, "\n")
  for x in range(1, len(ret) - 1)
    if ret[x] =~ '\<' . acommand . '\>\s\+'
      return substitute(ret[x+1], '\s*Last set from ', '', '')
    endif
  endfor
endfunction
function! scripting#edit_command(mods, pedit, command) abort
  try
    let file = scripting#locate_command(a:command)
  catch
    echoerr v:exception
  endtry
  if a:pedit
    exe a:mods 'pedit' file
    wincmd P
  elseif !empty(a:mods)
    exe a:mods 'new' file
  else
    exe 'edit' file
  endif
  call search('com.*\<\zs'. a:command . '\>')
  if a:pedit
    normal zt
  else
    normal zz
  endif
endfunction

" echoerr inside try block (including the catch finally) will raise an exception
" when a function contains echoerr, whether the code after echoerr will be
" executed or not depends on whether the caller puts the function inside a try
" block. This may cause inconsistence. So it is better to exit the function
" whenever there is a need to call echoerr.

function! scripting#locate_map(type, command, index) abort
  let acommand = a:command == ''? expand("<cword>") : a:command
  let output = execute('verb ' . a:type . 'map ' . acommand)
  let ret = split(output, "\n")
  if len(ret) == 2
    return substitute(ret[1], '\s*Last set from ', '', '')
  elseif a:index > 0
    return substitute(ret[2*a:index -1], '\s*Last set from ', '', '')
  else
    echo "\n"
    for i in range(len(ret))
      if (i%2 == 0)
        echo (i/2+1) ret[i] ret[i+1]
      endif
    endfor
    let N = len(ret)/2
    let prompt = printf("select [1-%d] >> ", N)
    let n = 0
    while (n > N || n < 1)
      let in = input({'prompt': prompt, 'cancelreturn': '-'})
      if in == '-'
        throw 'Cancled'
      endif
      let n = str2nr(in)
    endwhile
    return substitute(ret[2*n -1], '\s*Last set from ', '', '')
  endif
endfunction
function! scripting#edit_map(mods, pedit, type, command, ...) abort
  let acommand = a:command
  let index = a:0 == 0? 0 : a:1
  try
    let file = call('scripting#locate_map', [a:type, acommand, index])
  catch
    return
  endtry
  let command = acommand[0] == ';'? ('\(<leader>\|;\)' . acommand[1:]) : acommand
  if a:pedit
    exe a:mods 'pedit' file
    wincmd P
  elseif !empty(a:mods)
    exe a:mods 'new' file
  else
    exe 'edit' file
  endif
  let pattern = '\c.*map .*\zs' . command . ' '
  call search(pattern,  '')
  if a:pedit
    normal zt
  else
    normal zz
  endif
endfunction

function! scripting#locate_function(functionname) abort
  let output = execute('verb function ' . a:functionname)
  let ret = split(output, "\n")
  return substitute(ret[1], '\s*Last set from ', '', '')
endfunction
function! scripting#edit_function(mods, pedit, function) abort
  let afunction = a:function == ''? expand("<cword>") : a:function
  try
    if afunction =~# '^s:'
      " the same file
    else
      let file = scripting#locate_function(afunction)
      if a:pedit
        exe a:mods 'pedit' file
        wincmd P
      elseif !empty(a:mods)
        exe a:mods 'new' file
      else
        exe 'edit' file
      endif
    endif
  catch
    echoerr v:exception
  endtry
  call search('function!\?\s\+\<\zs'. afunction . '\>')
  if a:pedit
    normal zt
  else
    normal zz
  endif
endfunction

function! scripting#ExeLines() range
  let tmp = scripting#SaveRegister("#")
  let file = tempname()
  try
    exe ("silent " . a:firstline . "," . a:lastline . "write " . file)
    exe 'so'  file
  finally
    call scripting#RestoreRegister(tmp)
    call delete(file)
  endtry
endfunction

function! scripting#ExeReg(reg)
  exec join(getreg(a:reg, 1, 1), "|")
endfunction

function! scripting#SaveRegister(reg)
  " if a:reg == "=", the second parameter 1 will make the function return the
  " express instead of the number
  return [a:reg, getreg(a:reg, 1), getregtype(a:reg)]
endfunction
function! scripting#RestoreRegister(values)
  call setreg(a:values[0], a:values[1], a:values[2])
endfunction

function! scripting#CopyRegister(regfrom, ...)
  " only the first character is used
  let regto = get(a:000, 0, '*')[0]
  let regfrom = a:regfrom[0]
  if regfrom == regto
    return
  endif
  call setreg(regto, getreg(regfrom, 1), getregtype(regfrom))
endfunction

function! scripting#SaveMark(mk)
  let themark = "'" . a:mk
  let saved = getpos(themark)
  return [themark, saved]
endfunction
function! scripting#RestoreMark(saved)
  call setpos(saved[0], saved[1])
endfunction

" escape the args so that can be feed to commandline or 'exec'
function! scripting#escape(string, ...)
  let esc = get(a:000, 0, '\ ')
  return escape(a:string, esc)
endfunction

" used in lambda to execute some commands
" positional: [retvar] replace the return value
function! scripting#exe(cmd, ...)
  let rv = execute(a:cmd)
  return get(a:000, 0, rv)
endfunction

function! scripting#echo(...)
  for x in a:000
    echon x ' '
  endfor
  echo ''
endfunction

function! scripting#GetMotionRange(type)
  if a:type=='line'
    return "'[V']"
  elseif a:type=='char'
    return "`[v`]"
  else
    return "`[\<C-V>`]"
  endif
endfunction

let s:pat_long = '^\s*--\([a-zA-Z0-9][-_/.a-zA-Z0-9]*\)\(\(+\?\)\([:$<%!]*\)=\(.*\)\)\?$'
let s:pat_short = '^\s*\([-+]\)\([$:%!]\?\)\([a-zA-Z0-9]\)\(.*\)$'
" starting whitespaces are trimmed, ending whitespaces are kept
" [key] represents meta-option, which affects how parser interprets the args
" known mega-options:
" -- [KMAP]: the map from --key or -key to the destination option
"            for example: [KMAP] = {'v': 'verbose'}
" -- [POSITIONAL]: if 2, then all args after the first positional
"                  arg are treaded as positional args
"                  if 1, then all args are positional
"                  if 0, then use '--' to start positional args (default)
function! scripting#parse(default_opts, qargs) abort
  "Log! a:qargs
  let opts = type(a:default_opts) == v:t_dict? a:default_opts : {}
  let keymap = scripting#pop(opts, '[KMAP]', {})
  let positionalmode = scripting#pop(opts, '[POSITIONAL]', '')
  let IFS = scripting#pop(opts, '[IFS]', '')
  function! s:_expand(mode, var)
    let modes = split(a:mode == ''? ':' : a:mode, '\zs')
    let var = a:var
    for mode in modes
      if mode == ':'            " as is
        let var = var
      elseif mode == '$'        " evaluate
        let var = eval(var)
      elseif mode == '<'        " expand
        let var = expand(var)
      elseif mode == '%'        " fnameescape
        let var = fnameescape(var)
      elseif mode == '!'        " shellescape
        let var = shellescape(var)
      endif
    endfor
    return var
  endfunction

  function! s:_add(opts, keymap, key, varpart, append, modes, var)
    let key = get(a:keymap, a:key, a:key)
    if a:varpart == ''
      let a:opts[key] = '1DEFAULT'  " if '1DEFAULT' evaluates to true
      return
    endif
    let var = s:_expand(a:modes, a:var)
    if !a:append
      let a:opts[key] = var
    elseif has_key(a:opts, key)
      if type(a:opts[key]) == v:t_list
        call add(a:opts[key], var)
      else
        let a:opts[key] = [a:opts[key], var]
      endif
    else
      let a:opts[key] = [var]
    endif
  endfunction

  let args = scripting#split(a:qargs, IFS)
  if positionalmode != 'all'
    let lst = []
    for idx in range(len(args))
      let x = args[idx]
      if x =~ s:pat_long
        let [key, varpt, append, modes, var] = matchlist(x, s:pat_long)[1:5]
        call s:_add(opts, keymap, key, varpt, append=='+', modes, var)
      elseif x =~ s:pat_short
        let [append, mode, key, var] = matchlist(x, s:pat_short)[1:4]
        call s:_add(opts, keymap, key, var, append=='+', mode, var)
      else
        if x =~ '^\s*--$'
          let lst = args[idx+1:]
          break
        elseif positionalmode == 'auto'
          let lst = args[idx:]
          break
        else
          call add(lst, x)
        endif
      endif
    endfor
  else
    let lst = args
  endif

  let pat_with_modes = '^\s*\(.\{-}\)\(@\(@\?\)\([:$<%!]\+\)\)\?$'
  let args = []
  let last_modes = ':'
  for x in lst
    let matched = matchlist(x, pat_with_modes)
    let [var, hasmodes, savemodes, modes] = matched[1:4]
    if hasmodes == ''
      let modes = last_modes
    elseif savemodes == '@'
      let last_modes = modes
    endif
    call add(args, s:_expand(modes, var))
  endfor
  if get(opts, 'verbose', 0) || get(opts, 'v', 0)
    echomsg "Args:" string(opts) string(args)
  endif
  return [opts, args]
endfunction

" positional: [IFS]
function! scripting#split(str, ...)
  let IFS = get(a:000, 0, '')
  let IFS = IFS==''?get(g:, 'IFS', ''):IFS
  if IFS == ''
py3 << EOF
import vim, shlex
string = vim.eval('a:str')
vim.vars['l:tmp'] = shlex.split(string)
EOF
    let rv = remove(g:, 'l:tmp')
    return rv
  else
    " only get one character
    let rv = split(a:str, printf('\(%s\)\+', IFS))
    return rv
  endif
endfunction

function! scripting#pop(dict, key, default)
  if has_key(a:dict, a:key)
    return remove(a:dict, a:key)
  else
    return a:default
endfunction

function! scripting#complete(ArgLead, CmdLine, CursorPos)
  let args = scripting#split(a:CmdLine[:a:CursorPos-1])[1:-2]
  let positional = 0
  for arg in args
    if arg =~ s:pat_long
      continue
    elseif arg =~ s:pat_short
      continue
    elseif arg == '--'
      continue
    else
      let positional = 1
    endif
  endfor
  "Log! a:ArgLead . '|' . a:CmdLine . '|' .   a:CursorPos . '|'. string(args)
  "return getcompletion("*", 'dir')
  return getcompletion(a:ArgLead, 'shellcmd')
endfunction

function! scripting#with_ifs(command)
  let oldifs = g:IFS
  try
    let [g:IFS, command] = matchlist(a:command, '\(\S\+\)\(\s.*\)')[1:2]
    exe command
  finally
    let g:IFS = oldifs
  endtry
endfunction

