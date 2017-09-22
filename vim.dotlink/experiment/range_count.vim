
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
*******************
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
"    if no -addr:
"        return c
"    else:
"        return 1
" else (-range=N or no -range)
"    return 1
