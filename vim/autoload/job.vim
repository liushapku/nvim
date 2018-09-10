let s:Shell = {'exit_code':''}
function s:Shell.send(...)
  if a:0 == 0
    call chanclose(self.id, 'stdin')
  else
    for data in a:000
      call chansend(self.id, data)
    endfor
  endif
endfunction

function! job#quickfix(instance, position, title) abort
  if has_key(a:instance, 'efm')
    let efm = &efm
    let &efm = a:instance.efm
  endif
  try
    let title = 'Job: ' . a:title
    if a:position == 'l'
      lgetexpr a:instance.chunks
      call setloclist([], 'r', {'title': title})
      belowright lopen
    else
      cgetexpr a:instance.chunks
      call setqflist([], 'r', {'title': title})
      botright copen
    endif
    let w:quickfix_title = title
  finally
    if has_key(a:instance, 'efm')
      let &efm = efm
    endif
  endtry
endfunction

function! job#default_callback(jobid, data, event) dict
  if ! has_key(self, 'chunks')
    let self.chunks = ['']
  endif
  if a:event == 'exit'
    let self.data = copy(self.chunks)
    if has_key(self, 'filter')
      call filter(self.chunks, self.filter)
    endif
    if has_key(self, 'map')
      call map(self.chunks, self.map)
    endif
    if has_key(self, 'transform')
      let self.chunks = self.transform(self.chunks)
    endif
    let self.exit_code = a:data
    let Onexit = get(self, 'onexit', 'echo')
    if type(Onexit) == v:t_func
      call Onexit(self)
    elseif type(Onexit) == v:t_list
      for line in Onexit
        exe line
      endfor
    elseif Onexit == 'echo'
      echo join(self.chunks, "\n")
    elseif Onexit == 'copen'
      call job#quickfix(self, 'q', string(self.cmd))
    elseif Onexit == 'lopen'
      call job#quickfix(self, 'l', string(self.cmd))
    elseif Onexit =~# '\(v\|tab\)\?new\($\| .*\)'
      exe Onexit
      call append(0, self.chunks[:-2])
    elseif type(Onexit) == v:t_string && Onexit =~# '^:'
      exe Onexit
    else
      echoerr 'unknown Onexit: ' . string(Onexit)
    endif
    return
  elseif a:data == ['']
    " last data for stdout and stderr
    return
  endif

  let self.chunks[-1] .= a:data[0]
  call extend(self.chunks, a:data[1:])

  if a:event == 'stdout'
    if has_key(self, 'onstdout')
      call self.onstdout()
    endif
  elseif a:event == 'stderr'
    if has_key(self, 'onstderr')
      call self.onstderr()
    endif
  endif
endfunction

let s:list = {}
let s:list.jobs = {}
let s:list.last = -100
let job#list = s:list

function! s:list.list()
  for key in keys(self.jobs)
    let inst = self.jobs[key]
    echo key inst.cmd inst.exit_code
  endfor
endfunction
function! s:list.get(id)
  return self.jobs[a:id]
endfunction
function! s:list.kill(id)
  if has_key(self.jobs, id)
    call jobstop(a:id)
  endif
endfunction
function! s:list.remove(id)
  if has_key(self.jobs, id)
    return remove(self.jobs, id)
  else
    echoerr id . " not in job list"
  endif
endfunction
function! s:list.clear()
  let self.jobs = {}
endfunction
function! s:list.add(id, instance)
  let self.jobs[a:id] = a:instance
  let self.last = a:id
endfunction

function! job#new(options, cmd) abort
  " optional para:
  " a:1: options dict
  let instance = extend(copy(s:Shell), a:options)
  let Callback = get(instance, 'callback', function('job#default_callback'))
  let instance.on_stdout = Callback
  let instance.on_stderr = Callback
  let instance.on_exit = Callback
  let buffered = get(instance, 'buf', 1)
  let instance.stdout_buffered = 1
  let instance.stderr_buffered = 1
  let instance.cmd = type(a:cmd) == type([])? copy(a:cmd) : ['sh', '-c', a:cmd]
  let id = jobstart(instance.cmd, instance)
  let instance.id = id
  call s:list.add(id, instance)

  if has_key(instance, 'input')
    let input = instance.input
    call instance.send(input)
  elseif has_key(instance, '@range')
    let [l1, l2] = instance['@range']
    let input = getline(l1, l2)
    call instance.send(input)
  endif
  if get(instance, 'eof', 0)
    call instance.send()
  endif
  if get(a:options, 'verbose', 0) || get(a:options, 'v', 0)
    echomsg printf('job id: %d: %s', id, a:cmd)
  endif
  return instance.id
endfunction

function! job#spawn(parsed_args)
  let [options, cmd] = a:parsed_args
  if !scripting#pop(options, '@list', 1)
    let cmd = join(cmd)
  endif
  return job#new(options, cmd)
endfunction

function! job#kill(...)
  let instance = get(a:000, 0, g:last_job)
  let id = type(instance) == v:t_dict? instance.id : instance
  call jobstop(id)
endfunction
