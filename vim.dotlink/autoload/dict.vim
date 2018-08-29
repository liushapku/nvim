function! dict#StringToDict(dic, reverse) abort
  " \@! negative look forward
  let result = {}
  for r in a:dic
    if r !~ "="
      continue
    endif
    if a:reverse
      let [val; key] = split(r, "=")
      let key = join(key, "=")
    else
      let [key; val] = split(r, "=")
      let val = join(val, "=")
    endif
    let key = string#Strip(key)
    let val = string#Strip(val)
    let result[key] = val
  endfor
  return result
endfunction

function! dict#GetLines(line1, line2, reg, force, reverse) abort
  let dic=dict#StringToDict(getline(a:line1, a:line2), a:reverse)
  if exists('g:dict#replace_dic')
    let method = a:force ? 'force' : 'keep'
    call extend(g:dict#replace_dic, dic, method)
  else
    let g:dict#replace_dic = dic
  endif
  exe a:line1 . "," . a:line2 . "delete " . a:reg
endfunction

function! dict#Get(motion_wise) abort
  " all are linewise
  let line1 = line("'[")
  let line2 = line("']")
  call dict#GetLines(line1, line2, "", 0, 0)
endfunction

function! dict#GET(motion_wise) abort
  " all are linewise
  let line1 = line("'[")
  let line2 = line("']")
  call dict#GetLines(line1, line2, "", 0, 1)
endfunction

function! dict#Replace(motion_wiseness) abort
  " all are characterwise
  let saved = SaveRegister("t")
  silent normal! `[v`]"ty
  try
    let text = get(g:dict#replace_dic, string#Strip(@t))
    if text isnot 0
      echo text
      silent normal gv"=textp
    endif
  finally
    call RestoreRegister(saved)
  endtry
endfunction


