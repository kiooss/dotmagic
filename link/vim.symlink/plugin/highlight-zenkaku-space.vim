autocmd FileType * call <SID>SetupAutoCommands()
autocmd WinEnter,BufWinEnter * call <SID>SetupAutoCommands()
autocmd ColorScheme * call <SID>ZenkakuSpaceInit()

let s:zenkaku_space_initialized = 0
function! <SID>SetupAutoCommands()
  augroup ZenkakuSpace
    autocmd!

    if s:zenkaku_space_initialized == 0
      call <SID>ZenkakuSpaceInit()
    endif

    call <SID>HighlightZenkakuSpace()
    autocmd InsertEnter * call <SID>HighlightZenkakuSpace()
    autocmd InsertLeave,BufReadPost * call <SID>HighlightZenkakuSpace()
  augroup END
endfunction

function! s:ZenkakuSpaceInit()
  highlight ZenkakuSpace cterm=reverse ctermfg=Gray gui=reverse guifg=Gray
  let s:zenkaku_space_initialized = 1
endfunction

function! s:HighlightZenkakuSpace()
  call s:PerformSyntaxHighlight('[\u3000]\+')
endfunction

function! s:PerformSyntaxHighlight(pattern)
  syn clear ZenkakuSpace
  exe 'syn match ZenkakuSpace excludenl "' . a:pattern . '"'
endfunction
