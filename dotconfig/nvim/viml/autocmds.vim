"==============================================================================
" autocmds.vim---Autocmds settings.
" => Yang Yang
"==============================================================================

" Set augroup.
augroup MyAutoCmd
  autocmd!
augroup END

" Reload vim config automatically {{{
execute 'autocmd MyAutoCmd BufWritePost '.$VIMPATH.'/* nested'
      \ .' source $MYVIMRC | redraw | silent doautocmd ColorScheme'
      \ .' | echom "config reloaded!"'
" }}}

augroup MyAutoCmd
  " {{{ file type specific settings
  autocmd FileType php setlocal ts=4 sts=4 sw=4 expandtab
  autocmd FileType vim setlocal ts=2 sts=2 sw=2 expandtab
  autocmd FileType coffee setlocal ts=2 sts=2 sw=2 expandtab
  autocmd FileType zsh,bash,sh setlocal ts=2 sts=2 sw=2 expandtab
  autocmd FileType crontab setlocal nobackup nowritebackup

  autocmd FileType xml setlocal equalprg=xmllint\ --format\ --recover\ -\ 2>/dev/null

  autocmd FileType gitcommit setlocal spell
  autocmd FileType gitcommit,qfreplace setlocal nofoldenable
  " make quickfix windows take all the lower section of the screen
  " when there are multiple windows open
  autocmd FileType qf wincmd J
  autocmd FileType qf noremap <buffer> q :q<cr>
  autocmd FileType apache setlocal commentstring=#\ %s
  autocmd FileType php setlocal commentstring=//\ %s
  autocmd FileType gitconfig setlocal commentstring=#\ %s
  autocmd FileType vue setlocal commentstring=//\ %s
  autocmd FileType typescript setlocal commentstring=//\ %s
  autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab indentkeys-=0# indentkeys-=<:>
  " }}}

  autocmd BufReadPost *.log normal! G
  " remove spaces at the end of line
  autocmd BufWritePre * :%s/\s\+$//e
  " automatically resize panes on resize
  autocmd VimResized * exe 'normal! \<c-w>='
  " save all files on focus lost, ignoring warnings about untitled buffers
  autocmd FocusLost * silent! wa
  " Check if file changed when its window is focus, more eager than 'autoread'
  autocmd WinEnter,FocusGained * checktime

  autocmd Syntax * if 5000 < line('$') | syntax sync minlines=200 | endif

  " autocmd FileType * execute 'setlocal dict+='.$VIMPATH.'/words/'.&filetype.'.txt'
  autocmd FileType vue syntax sync fromstart
  " autocmd BufRead,BufNewFile *.vue setlocal filetype=vue.html.javascript.css.less.pug


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

  autocmd FileType *
        \ if &ft ==# 'dirvish'
        \ |   GitGutterDisable
        \ | else
          \ |   GitGutterEnable
          \ | endif
  " Show absolute numbers in insert mode, otherwise relative line numbers.
  autocmd InsertEnter *
        \ if &relativenumber | setlocal norelativenumber | endif |
  autocmd InsertLeave *
        \ if &number | setlocal relativenumber | endif |

  " Disable paste.
  autocmd InsertLeave *
        \ if &paste | setlocal nopaste | echo 'nopaste' | endif |
      \ if &l:diff | diffupdate | endif

  " FastFold
" Credits: https://github.com/Shougo/shougo-s-github
  autocmd TextChangedI,TextChanged *
    \ if &l:foldenable && &l:foldmethod !=# 'manual' |
    \   let b:foldmethod_save = &l:foldmethod |
    \   let &l:foldmethod = 'manual' |
    \ endif

  autocmd BufWritePost *
    \ if &l:foldmethod ==# 'manual' && exists('b:foldmethod_save') |
    \   let &l:foldmethod = b:foldmethod_save |
    \   execute 'normal! zx' |
    \ endif

  " window hlight
  " Make current window more obvious by turning off/adjusting some features
  " in non-current windows.
  if exists('+winhighlight')
    autocmd BufEnter,FocusGained,VimEnter,WinEnter * if <sid>should_colorcolumn() | set winhighlight= | endif
    autocmd FocusLost,WinLeave * if <sid>should_colorcolumn()
          \ | set winhighlight=CursorLineNr:LineNr,IncSearch:ColorColumn,Normal:ColorColumn,NormalNC:ColorColumn,SignColumn:ColorColumn | endif
    if exists('+colorcolumn')
      autocmd BufEnter,FocusGained,VimEnter,WinEnter * if <sid>should_colorcolumn() | let &l:colorcolumn='+' . join(range(1, 254), ',+') | endif
    endif
  elseif exists('+colorcolumn')
    autocmd BufEnter,FocusGained,VimEnter,WinEnter * if <sid>should_colorcolumn() | let &l:colorcolumn='+' . join(range(1, 254), ',+') | endif
    autocmd FocusLost,WinLeave * if <sid>should_colorcolumn() | let &l:colorcolumn=join(range(1, 255), ',') | endif
  endif

  " Automatic rename of tmux window
  if exists('$TMUX') && !exists('$NORENAME')
    autocmd BufEnter * if empty(&buftype) | call system('tmux rename-window '.expand('%:t:S')) | endif
    autocmd VimLeave * call system('tmux set-window automatic-rename on')
  endif
augroup END

function! EmptyBuffer()
  if @% ==# "" && &filetype !=# "startify"
    setfiletype txt
  endif
endfunction

let g:ColorColumnBlacklist = ['diff', 'fugitiveblame', 'undotree', 'nerdtree', 'qf', 'list']

function! s:should_colorcolumn() abort
  return index(g:ColorColumnBlacklist, &filetype) == -1
endfunction

" vim: set ts=2 sw=2 tw=80 et fdm=marker fdl=0:
