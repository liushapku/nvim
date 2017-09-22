syntax clear
syntax match inputString /\<\w\+\>/
highlight link inputString Statement

syntax match inputIdentifier /\(--\)\zs[a-zA-Z0-9-]\+/
syntax match inputIdentifier /\(^-\|\s-\)\zs[a-zA-Z0-9]\>/
highlight link inputIdentifier Identifier

syntax match inputFloat /\(^\|\s\|=\)\zs\(\([1-9][0-9]*\.\?[0-9]*\)\|\([0-9]\?\.[0-9]\+\)\)\([Ee][+-]\?[0-9]\+\)\?\ze\(\s\|$\)/
highlight link inputFloat Float

syn match	inputComment		/\(^\|\s\)\zs#.*$/
hi link inputComment Comment

syn match inputDate /\(19\|20\)[0-9][0-9]-[01][0-9]-[0-3][0-9]/
hi link inputDate Define
