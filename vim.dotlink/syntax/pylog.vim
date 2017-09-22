syntax match pylogDebug      /^\[20.*: 1[0-9]@@.*].*$/ skipnl nextgroup=pylogDebugContinue
syntax match pylogWarning    /^\[20.*: 3[0-9]@@.*].\{-}\ze\(key=\)\?$/ skipnl nextgroup=pylogWarningContinue
syntax match pylogInfo       /^\[20.*: 20@@.*].*$/     skipnl nextgroup=pylogInfoContinue
syntax match pylogInfo2      /^\[20.*: 22@@.*].*$/     skipnl nextgroup=pylogInfo2Continue
syntax match pylogInfo5      /^\[20.*: 25@@.*].*$/     skipnl nextgroup=pylogInfo5Continue
syntax match pylogInfo7      /^\[20.*: 27@@.*].*$/     skipnl nextgroup=pylogInfo7Continue
syntax match pylogError      /^\[20.*: 4[0-9]@@.*].*$/ skipnl nextgroup=pylogErrorContinue
syntax match pylogCritical   /^\[20.*: 5[0-9]@@.*].*$/ skipnl nextgroup=pylogCriticalContinue

syntax match pylogDebugContinue    /^\(\[[12][09]\)\@!.*$/ skipnl contained nextgroup=pylogDebugContinue
syntax match pylogWarningContinue  /^\(\[[12][09]\)\@!.*$/ skipnl contained nextgroup=pylogWarningContinue
syntax match pylogInfoContinue     /^\(\[[12][09]\)\@!.*$/ skipnl contained nextgroup=pylogInfoContinue
syntax match pylogInfo2Continue    /^\(\[[12][09]\)\@!.*$/ skipnl contained nextgroup=pylogInfo2Continue
syntax match pylogInfo7Continue    /^\(\[[12][09]\)\@!.*$/ skipnl contained nextgroup=pylogInfo7Continue
syntax match pylogInfo5Continue    /^\(\[[12][09]\)\@!.*$/ skipnl contained nextgroup=pylogInfo5Continue
syntax match pylogErrorContinue    /^\(\[[12][09]\)\@!.*$/ skipnl contained nextgroup=pylogErrorContinue
syntax match pylogCriticalContinue /^\(\[[12][09]\)\@!.*$/ skipnl contained nextgroup=pylogCriticalContinue

syntax region pylogCacheKey start=/key=\n\[/ end=/]$/

hi pylogWarning       guifg=yellow     ctermfg=yellow
hi pylogInfo7         guifg=green      ctermfg=green
hi pylogInfo5         guifg=lightgreen ctermfg=lightgreen
hi pylogInfo2         guifg=lightcyan  ctermfg=lightcyan
hi pylogInfo          guifg=cyan       ctermfg=cyan
hi pylogError         guifg=red        ctermfg=red
hi pylogCritical      guibg=red        ctermbg=red        guifg=white ctermfg=white

hi pylogWarningContinue  guifg=yellow     ctermfg=yellow
hi pylogInfo7Continue    guifg=green      ctermfg=green
hi pylogInfo5Continue    guifg=lightgreen ctermfg=lightgreen
hi pylogInfo2Continue    guifg=lightcyan  ctermfg=lightcyan
hi pylogInfoContinue     guifg=cyan       ctermfg=cyan
hi pylogErrorContinue    guifg=red        ctermfg=red
hi pylogCriticalContinue guibg=red        ctermbg=red        guifg=white      ctermfg=white
hi pylogCacheKey         guibg=gray30     guifg=lightred     ctermfg=lightred ctermbg=gray

