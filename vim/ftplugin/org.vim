setlocal tabstop=2
setlocal softtabstop=2
setlocal shiftwidth=2

command! -buffer -range=0 -bang -bar -narg=? Orgtab call org#Fold(<line1>, <q-args>, <bang>0)
command! -buffer -bar -nargs=1 O2 call org#FoldPattern2(<q-args>)
command! -buffer -range=% -addr=windows -bar -nargs=1 WO2 <line1>,<line2>Windo O2 <args>

command! -buffer -range=0 -addr=windows CompareFile call org#Compare(<count>)
command! -buffer -range=% -nargs=1 -addr=windows -bar Compare call append('.', '# ' . <q-args> . ': ') | <line1>,<line2>Windo O2 <args> | + | startinsert!
