
function! terminal#TermInsert(string)
    call setreg("*", a:string)
    exe "normal a\<MiddleMouse>"
endfunction

function! terminal#CopyLastCommand()
    call search('\$\s\+\S', 'bce')
    normal v$Gy
    let s = join(split(@", "\n"), "")
	return s
	echo s
endfunction
