augroup EventLoggin
  autocmd!
  autocmd BufNewFile * Log BufNewFile
  autocmd BufReadPre * Log BufReadPre
  autocmd BufRead * Log BufRead
  autocmd BufReadPost * Log BufReadPost
  autocmd BufReadCmd * Log BufReadCmd
  autocmd FileReadPre * Log FileReadPre
  autocmd FileReadPost * Log FileReadPost
  autocmd FileReadCmd * Log FileReadCmd
  autocmd FilterReadPre * Log FilterReadPre
  autocmd FilterReadPost * Log FilterReadPost
  autocmd StdinReadPre * Log StdinReadPre
  autocmd StdinReadPost * Log StdinReadPost
  autocmd BufWrite * Log BufWrite
  autocmd BufWritePre * Log BufWritePre
  autocmd BufWritePost * Log BufWritePost
  autocmd BufWriteCmd * Log BufWriteCmd
  autocmd FileWritePre * Log FileWritePre
  autocmd FileWritePost * Log FileWritePost
  autocmd FileWriteCmd * Log FileWriteCmd
  autocmd FileAppendPre * Log FileAppendPre
  autocmd FileAppendPost * Log FileAppendPost
  autocmd FileAppendCmd * Log FileAppendCmd
  autocmd FilterWritePre * Log FilterWritePre
  autocmd FilterWritePost * Log FilterWritePost
  autocmd BufAdd * Log BufAdd
  autocmd BufCreate * Log BufCreate
  autocmd BufDelete * Log BufDelete
  autocmd BufWipeout * Log BufWipeout
  autocmd BufFilePre * Log BufFilePre
  autocmd BufFilePost * Log BufFilePost
  autocmd BufEnter * Log BufEnter
  autocmd BufLeave * Log BufLeave
  autocmd BufWinEnter * Log BufWinEnter
  autocmd BufWinLeave * Log BufWinLeave
  autocmd BufUnload * Log BufUnload
  autocmd BufHidden * Log BufHidden
  autocmd BufNew * Log BufNew
  "autocmd SwapExists * Log SwapExists
  autocmd FileType * Log FileType
  autocmd Syntax * Log Syntax
  "autocmd EncodingChanged * Log EncodingChanged
  autocmd TermChanged * Log TermChanged
  autocmd VimEnter * Log VimEnter
  autocmd GUIEnter * Log GUIEnter
  autocmd GUIFailed * Log GUIFailed
  autocmd TermResponse * Log TermResponse
  autocmd QuitPre * Log QuitPre
  autocmd VimLeavePre * Log VimLeavePre
  autocmd VimLeave * Log VimLeave
  autocmd FileChangedShell * Log FileChangedShell
  autocmd FileChangedShellPost * Log FileChangedShellPost
  autocmd FileChangedRO * Log FileChangedRO
  autocmd ShellCmdPost * Log ShellCmdPost
  autocmd ShellFilterPost * Log ShellFilterPost
  autocmd FuncUndefined * Log FuncUndefined
  autocmd SpellFileMissing * Log SpellFileMissing
  autocmd SourcePre * Log SourcePre
  autocmd SourceCmd * Log SourceCmd
  autocmd VimResized * Log VimResized
  autocmd FocusGained * Log FocusGained
  autocmd FocusLost * Log FocusLost
  autocmd CursorHold * Log CursorHold
  "autocmd CursorHoldI * Log CursorHoldI
  "autocmd CursorMoved * Log CursorMoved
  "autocmd CursorMovedI * Log CursorMovedI
  autocmd WinEnter * Log WinEnter
  autocmd WinLeave * Log WinLeave
  autocmd TabEnter * Log TabEnter
  autocmd TabLeave * Log TabLeave
  autocmd CmdwinEnter * Log CmdwinEnter
  autocmd CmdwinLeave * Log CmdwinLeave
  autocmd InsertEnter * Log InsertEnter
  "autocmd InsertChange * Log InsertChange
  autocmd InsertLeave * Log InsertLeave
  "autocmd InsertCharPre * Log InsertCharPre
  autocmd TextChanged * Log TextChanged
  "autocmd TextChangedI * Log TextChangedI
  autocmd ColorScheme * Log ColorScheme
  autocmd RemoteReply * Log RemoteReply
  autocmd QuickFixCmdPre * Log QuickFixCmdPre
  autocmd QuickFixCmdPost * Log QuickFixCmdPost
  autocmd SessionLoadPost * Log SessionLoadPost
  autocmd MenuPopup * Log MenuPopup
  autocmd CompleteDone * Log CompleteDone
  autocmd User * Log User
augroup END


" change window: if the other window has a diffrent buffer: BufLeave, WinLeave, WinEnter, BubEnter
" if the other window has the same buffer: WinLeave, WinEnter
"
" change buf in current window: BufLeave BufWinLeave BufHidden BufEnter BufWinEnter
"
" close window: if the alternative window has a different buffer: BufLeave WinLeave BufWinLeave BufHidden WinEnter BufEnter
"
" create buf in split: BufAdd BufCreate BufLeave BufReadCmd BufEnter BufWinEnter
