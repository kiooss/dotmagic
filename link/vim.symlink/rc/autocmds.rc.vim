"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Autocmd settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if !has('autocmd')
  finish
endif

" Reload vim config automatically {{{
execute 'autocmd MyAutoCmd BufWritePost '.g:Config_Main_Home.'/*,vimrc nested'
      \ .' source $MYVIMRC | redraw | silent doautocmd ColorScheme'
" }}}

augroup KioossAutocmds
  autocmd!
  " {{{ file type specific settings
  autocmd FileType php setlocal ts=4 sts=4 sw=4 expandtab
  autocmd FileType vim setlocal ts=2 sts=2 sw=2 expandtab
  autocmd FileType coffee setlocal ts=2 sts=2 sw=2 expandtab
  autocmd FileType zsh,bash,sh setlocal ts=2 sts=2 sw=2 expandtab
  autocmd FileType crontab setlocal nobackup nowritebackup

  autocmd FileType .xml exe ":silent %!xmllint --format --recover - 2>/dev/null"
  autocmd FileType gitcommit setlocal spell
  autocmd FileType gitcommit,qfreplace setlocal nofoldenable
  " make quickfix windows take all the lower section of the screen
  " when there are multiple windows open
  autocmd FileType qf wincmd J
  autocmd FileType qf noremap <buffer> q :q<cr>
  " }}}
  " remove spaces at the end of line
  autocmd BufWritePre * :%s/\s\+$//e
  " automatically resize panes on resize
  autocmd VimResized * exe 'normal! \<c-w>='
  " save all files on focus lost, ignoring warnings about untitled buffers
  autocmd FocusLost * silent! wa
  " Check if file changed when its window is focus, more eager than 'autoread'
  autocmd WinEnter,FocusGained * checktime

  autocmd Syntax * if 5000 < line('$') | syntax sync minlines=200 | endif

  " Update filetype on save if empty
  autocmd BufWritePost * nested
        \ if &l:filetype ==# '' || exists('b:ftdetect')
        \ |   unlet! b:ftdetect
        \ |   filetype detect
        \ | endif

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  autocmd BufReadPost *
        \ if &ft !~ '^git\c' && ! &diff && line("'\"") > 0 && line("'\"") <= line("$")
        \ |   execute 'normal! g`"zvzz'
        \ | endif

  " autocmd BufDelete * :call QuitIfLastBuffer()

  " Show absolute numbers in insert mode, otherwise relative line numbers.
  autocmd InsertEnter * :set norelativenumber
  autocmd InsertLeave * :set relativenumber

  " Disable paste.
  autocmd InsertLeave *
      \ if &paste | setlocal nopaste | echo 'nopaste' | endif |
      \ if &l:diff | diffupdate | endif

  " Automatic rename of tmux window
  if exists('$TMUX') && !exists('$NORENAME')
    autocmd BufEnter * if empty(&buftype) | call system('tmux rename-window '.expand('%:t:S')) | endif
    autocmd VimLeave * call system('tmux set-window automatic-rename on')
  endif

  " window hlight {{{
  " Make current window more obvious by turning off/adjusting some features
  " in non-current windows.
  if exists('+winhighlight')
    autocmd BufEnter,FocusGained,VimEnter,WinEnter * if kiooss#autocmds#should_colorcolumn() | set winhighlight= | endif
    autocmd FocusLost,WinLeave * if kiooss#autocmds#should_colorcolumn() | set winhighlight=CursorLineNr:LineNr,IncSearch:ColorColumn,Normal:ColorColumn,NormalNC:ColorColumn,SignColumn:ColorColumn | endif
    if exists('+colorcolumn')
      autocmd BufEnter,FocusGained,VimEnter,WinEnter * if kiooss#autocmds#should_colorcolumn() | let &l:colorcolumn='+' . join(range(0, 254), ',+') | endif
    endif
  elseif exists('+colorcolumn')
    autocmd BufEnter,FocusGained,VimEnter,WinEnter * if kiooss#autocmds#should_colorcolumn() | let &l:colorcolumn='+' . join(range(0, 254), ',+') | endif
    autocmd FocusLost,WinLeave * if kiooss#autocmds#should_colorcolumn() | let &l:colorcolumn=join(range(1, 255), ',') | endif
  endif "}}}
augroup END

if has('syntax')
  augroup on_change_colorschema
    autocmd!
    autocmd ColorScheme * call kiooss#autocmds#base16_customize()
  augroup END

  function! ZenkakuSpace() abort
    highlight ZenkakuSpace cterm=reverse ctermfg=DarkMagenta gui=reverse guifg=DarkMagenta
  endfunction

  augroup ZenkakuSpace
    autocmd!
    autocmd ColorScheme       * call ZenkakuSpace()
    autocmd VimEnter,WinEnter * match ZenkakuSpace /　/
  augroup END
  call ZenkakuSpace()
endif

if exists('##TextYankPost') && get(g:, 'check_clipper', 0)
  augroup check_clipper
    autocmd!
    autocmd TextYankPost * if v:event.operator ==# 'y' | call kiooss#autocmds#check_clipper() | endif
  augroup END
endif
