
function! log#Diff() abort
    let opt = ""
    if &diffopt =~ "icase"
        let opt = opt . " -i "
    endif
    if &diffopt =~ "iwhite"
        let opt = opt . "-b "
    endif
    let t1 = tempname()
    let t2 = tempname()
    silent exe "!sed -e 's/^\\[20.*] //' " . v:fname_in . ' > ' . t1
    silent exe "!sed -e 's/^\\[20.*] //' " . v:fname_new . ' > ' . t2
    silent exe "!diff -a --binary " . opt . t1 . " " . t2 . ' > ' . v:fname_out
    silent exe "!cp " . v:fname_out . " /tmp/a.diff"
endfunction
