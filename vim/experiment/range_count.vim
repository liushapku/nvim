command! -range                  TestRange1 : echo <count> <line1> <line2>
command! -range=%                TestRange2 : echo <count> <line1> <line2>
command! -range=3                TestRange3 : echo <count> <line1> <line2>
command! -range=0                TestRange4 : echo <count> <line1> <line2>
command! -range=-4               TestRange5 : echo <count> <line1> <line2>
command! -range=-4 -addr=windows TestRange6 : echo <count> <line1> <line2>
command! -range    -addr=windows TestRange7 : echo <count> <line1> <line2>
command! -range    -addr=buffers TestRange8 : echo <count> <line1> <line2>
command! -range=-999999          TestRange9 : echo <count> <line1> <line2>
command! -count                  TestCount1 : echo <count> <line1> <line2>
command! -count=3                TestCount2 : echo <count> <line1> <line2>
command! -count=0                TestCount3 : echo <count> <line1> <line2>
command! -count=-3               TestCount4 : echo <count> <line1> <line2>
command!                         TestNoop1  : echo <count> <line1> <line2>
command!           -addr=windows TestNoop2  : echo <count> <line1> <line2>
command!           -addr=buffers TestNoop3  : echo <count> <line1> <line2>

" |                            | <count>   | <line1> | <line2>         |
" | :mCommand                  | f(m)      | f(m)    | f(m)            |
" | :0Command -range[=%]       | 1         | 1       | 1               |
" | :0Command -{range,count}=N | 0         | 0       | 0               |
" | :nCommand                  | n         | n       | n               |
" | :-nCommand                 | c-n       | c-n     | c-n             |
" | :l1,l2Command              | f(l2)     | f(l1)   | f(l2)           |
" | :Command n -count[=N]      | n         | c       | n               |
" | :Command                   | ****      | ****    | ****            |
" |     -range                 | -1        | c       | -addr=line? c:1 |
" |     -range=%               | -1        | 1       | $               |
" |     -range=N               | N         | c       | 1               |
" |     -count                 | 0         | c       | 1               |
" |     -count=N               | N>=0? N:0 | c       | 1               |
" |     -nothing-              | -1        | c       | -addr=line? c:1 |

"c = current line/buffer... depending on -addr
"$ = the last line/buffer... depending on -addr
"m is any integer, n is positive integer
"l1,l2 should be a valid range,
"-nothing- means no -range[=x] nor -count[=x] is specified
