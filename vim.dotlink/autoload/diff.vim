
function! diff#Patch0(file, basedir)
  let f = readfile(a:file)
  let line1 = -1
  for n in range(len(f))
    let x = f[n]
    if x =~ '^diff.* a/.* b/.*'
      let filenames = split(substitute(x, '^diff.* a/\(.*\) b/\(.*\)', '\1\t\2', ''), "\t")
      let file1 = resolve(fnamemodify(a:basedir . filenames[0], ':p'))
      let thisfile = resolve(fnamemodify(@%, ':p'))
      if file1 == thisfile
        let line1 = n
        break
      endif
    endif
  endfor
  if line1 == -1
    return
  endif

  let line2 = len(f) - 1
  for n in range(line1 + 1, len(f) - 1)
    let x = f[n]
    if x =~ '^diff.* a/.* b/.*'
      let line2 = n - 1
    endif
  endfor
  echo f[line1:line2]
  "let switch=buffer#SwitchToBuffer('neoterm-' . g:current_neoterm)
  "normal G
  "let l1 = search('^diff.* a/.* b/.*', 'bc')
  "call buffer#SwitchBack(switch)
  "echo l1
endfunction

function! diff#ReversePatch()
   call system("patch -R -o " . v:fname_out . " " . v:fname_in . " < " . v:fname_diff)
endfunction
function! diff#Patch(patchfile, reverse)
  if a:reverse
    let oldpatchexpr = &patchexpr
    set patchexpr=diff#ReversePatch()
    try
      exe 'diffpatch' a:patchfile
    finally
      let &patchexpr = oldpatchexpr
    endtry
  else
    exe 'diffpatch' a:patchfile
  endif
endfunction
