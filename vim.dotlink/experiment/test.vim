" For <line1>: when range is specified or range is not specified but -range=%
" or -range, it will get a new value (c for -range, 1 for -range=%), otherwise it is c
" psudo code
" if hasrange
"     line1 = line1
" else
"     use line1 default
" where line1 default =
" if has -range=%
"     return = 1
" else
"     return = c
" *******************
" for <count> and <line2>
" if hascount
"    count = line2 = count
" elif hasrange
"    count = line2 = line2
" else
"    use count default
"    use line2 default
"
" where count default =
" if has -count=N
"    return N>=0? N: 0
" elif has -range=N
"    return N
" else
"    return -1
"
" where line2 default =
" if has -range=%
"    return $
" else has -range
"    return c
" else (-range=N or no -range)
"    return 1
"function! EchoArgs(args)
"    echo len(a:args)
"    echo a:args
"endfunction
"command! -nargs=* EchoArgs call EchoArgs(<q-args>)

function! ShowCount(count, line1, line2)
    echo v:count v:count1 a:count a:line1 a:line2
endfunction

" v:count and v:count1 are not affected by command, they are for maps only
" c means current line
" if range is specified, <count>=<line2>, <line1> and <line2> is from range
" if no range is specified, -range=N: <count>=N,  <line1>=c, <line2>=1
" if no range is specified, -count=N: <count>=N,  <line1>=c, <line2>=1
" if no range is specified, -range=%: <count>=-1, <line1>=1, <line2>=$
" if no range is specified, -range  : <count>=-1, <line1>=c, <line2>=c
command! -range=% -addr=windows TestRange echo v:count v:count1 <q-count> <q-line1> <q-line2>
command! -range=3 TestRange echo v:count v:count1 <q-count> <q-line1> <q-line2>
command! -range=-1 TestRange echo v:count v:count1 <q-count> <q-line1> <q-line2>
command! -range  TestRange echo v:count v:count1 <q-count> <q-line1> <q-line2>
" TestRange:    0 1 3 c 1   "with -range=3
" TestRange:    0 1 -1 c 1   "with -range=-1
" TestRange:    0 1 -1 1 $   "with -range=%
" TestRange:    0 1 -1 c c   "with -range
" -1TestRange:  0 1 c-1 c-1 c-1
" .TestRange:   0 1 c c c
" 0TestRange:   0 1 0 0 0
" 1TestRange:   0 1 1 1 1
" 3,4TestRange: 0 1 4 3 4

" if count is specified at count position: <count>=count, <line1>=c, <line2>=<count>
" if count is specified at range position: <count>=count, <line1>=<count>, <line2>=<count>
" if count is not specified: <count>=default >=0? default: 0, <line1>=c, <line2>=1
command! -count=0 TestCount echo v:count v:count1 <q-count> <q-line1> <q-line2>
command! -count=3 TestCount echo v:count v:count1 <q-count> <q-line1> <q-line2>
command! -count=-1 TestCount echo v:count v:count1 <q-count> <q-line1> <q-line2>
" v:count v:count1 <count> <line1> <line2>
" TestCount:    0 1 0 c 1   "with -count=-1
" TestCount:    0 1 3 c 1   "with -count=3
" -1TestCount:  0 1 c-1 c-1 c-1
" .TestCount:   0 1 c c c
" 0TestCount:   0 1 0 0 0
" TestCount 0:  0 1 0 c 0
" 1TestCount:   0 1 1 1 1
" TestCount 1:  0 1 1 c 1
" 3,4TestCount: 0 1 4 3 4

command! -range -count=-3 TestRC echo v:count v:count1 <q-count> <q-line1> <q-line2>
command! -range=% -count=33 TestRC echo v:count v:count1 <q-count> <q-line1> <q-line2>
command! -range -count=33 TestRC echo v:count v:count1 <q-count> <q-line1> <q-line2>
" TestRC:       0 1 3 c 1   "with -count=3
" 1TestRC:      0 1 1 1 1
" 3,4TestRC:    0 1 4 3 4
" 3,4TestRC 8:  0 1 8 3 8
" 3TestRC 8
"
" <line2>: end of range if range is specified, otherwise 1
" <line1>: begin of range if range is specified, otherwise current line
" <count>: if range or count is specified, end of range; otherwise if -count, use count default
" floored at 0; otherwise if -range=N use range default; otherwise if -range or -range=%, -1;
" <count> in -range=N: if range is specified, end of range; otherwise N; even
" if N < 0
"

command! -range=0 -addr=windows TestRange echo v:count v:count1 <q-count> <q-line1> <q-line2>
command! -range=-4 -addr=windows TestRange echo v:count v:count1 <q-count> <q-line1> <q-line2>
command! -count=-4 -addr=windows TestCount echo v:count v:count1 <q-count> <q-line1> <q-line2>
" TestRange: 0 1 -4 c 1
" TestCount: 0 1 0 c 1
" 2,3TestRange: 0 1 3 2 3
" 2,3TestCount: 0 1 3 2 3
" %TestRange: 0 1 N 1 N
" %TestCount: 0 1 N 1 N
" TestCount 5: 0 1 5 c 5
" 5TestCount: 0 1 5 5 5
"
command! -range -addr=windows Test echo v:count v:count1 <q-count> <q-line1> <q-line2>
