
" see :h job-control-usage
let s:Shell = {}
function! job#default_callback(jobid, data, event) dict
  if a:event == 'exit'
    let onexit = get(self, 'onexit', 'echo')
    if onexit == 'echo'
      echo join(self.chunks, "\n")
    elseif onexit == 'qf'
      cexpr self.chunks
      call setqflist([], ' ', {'title': self.name})
      botright copen
    else
      call self.onexit()
    endif
    return
  elseif a:data == ['']
    " last data for stdout and stderr
    return
  endif

  if ! has_key(self, '_chunks')
    let self.chunks = ['']
  endif
  let self.chunks[-1] .= a:data[0]
  call extend(self.chunks, a:data[1:])

  if a:event == 'stdout'
    "
  elseif a:event == 'stderr'
    "
  else
    "
  endif
endfunction

function! job#exited() dict
  cexpr self.chunks
endfunction

function! Test_dict() dict
  echo self.test
endfunction

function! job#new(name, cmd, ...)
  " optional para:
  " a:1: call back
  " a:2: options dict
  let instance = extend(copy(s:Shell), {'name': a:name})
  let Callback = a:0 > 0? a:1 : function('job#default_callback')
  if a:0 > 1
    call extend(instance, a:2)
  endif
  let instance.on_stdout = Callback
  let instance.on_stderr = Callback
  let instance.on_exit = Callback
  let instance.cmd = type(a:cmd) == type([])? a:cmd : ['sh', '-c', a:cmd]
  let instance.id = jobstart(instance.cmd, instance)
  return instance
endfunction
