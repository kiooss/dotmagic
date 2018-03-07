"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Autocmd settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if !has('autocmd')
  finish
endif

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
  " close help only with q
  autocmd FileType help noremap <buffer> q :q<cr>
  autocmd FileType help wincmd L
  " make quickfix windows take all the lower section of the screen
  " when there are multiple windows open
  autocmd FileType qf wincmd J
  autocmd FileType qf noremap <buffer> q :q<cr>
  " }}}

  " remove spaces at the end of line
  autocmd BufWritePre * :%s/\s\+$//e

  autocmd BufRead,BufNewFile *.js set filetype=javascript.jsx
  autocmd BufRead,BufNewFile *_js.html.erb set filetype=javascript
  autocmd BufRead,BufNewFile *_js.html.twig set filetype=javascript
  autocmd BufRead,BufNewFile *.xlsx.axlsx set filetype=ruby
  autocmd BufRead,BufNewFile *.ihtml set filetype=php
  autocmd BufRead,BufNewFile *.ejs set filetype=html
  autocmd BufRead,BufNewFile *.ino set filetype=c
  autocmd BufRead,BufNewFile *.svg set filetype=xml
  autocmd BufRead,BufNewFile *.tmuxtheme set filetype=tmux

  autocmd BufNewFile,BufReadPost *.md set filetype=markdown

  " automatically resize panes on resize
  autocmd VimResized * exe 'normal! \<c-w>='
  autocmd BufWritePost .vimrc,vimrc,*.rc.vim,*.toml call kiooss#autocmds#vim_refresh()
  " save all files on focus lost, ignoring warnings about untitled buffers
  autocmd FocusLost * silent! wa

  " autocmd BufDelete * :call QuitIfLastBuffer()

  " Show absolute numbers in insert mode, otherwise relative line numbers.
  autocmd InsertEnter * :set norelativenumber
  autocmd InsertLeave * :set relativenumber

  " Disable paste.
  autocmd InsertLeave *
        \ if &paste | setlocal nopaste | echo 'nopaste' | endif |
        \ if &l:diff | diffupdate | endif

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
endif

if exists('##TextYankPost') && get(g:, 'check_clipper', 0)
  augroup check_clipper
    autocmd!
    autocmd TextYankPost * if v:event.operator ==# 'y' | call kiooss#autocmds#check_clipper() | endif
  augroup END
endif
