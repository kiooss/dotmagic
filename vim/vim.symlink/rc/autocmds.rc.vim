"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Autocmd settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" {{{ file type specific settings
if has('autocmd')
  augroup KioossAutocmds
    autocmd!

    " php
    autocmd FileType php set dictionary+=~/.vim/php.dict

    autocmd FileType php setlocal ts=4 sts=4 sw=4 expandtab
    autocmd FileType ruby setlocal ts=2 sts=2 sw=2 expandtab
    autocmd FileType vim setlocal ts=2 sts=2 sw=2 expandtab
    autocmd FileType coffee setlocal ts=2 sts=2 sw=2 expandtab
    autocmd FileType zsh setlocal ts=2 sts=2 sw=2 expandtab
    autocmd FileType crontab setlocal nobackup nowritebackup

    "ruby
    autocmd FileType ruby,eruby set omnifunc=rubycomplete#Complete
    autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
    autocmd FileType ruby,eruby let g:rubycomplete_rails = 1
    autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1

    autocmd FileType .xml exe ":silent %!xmllint --format --recover - 2>/dev/null"

    autocmd FileType gitcommit setlocal spell

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
    autocmd BufWritePost .vimrc,vimrc,*.rc.vim,*.toml source $MYVIMRC | AirlineRefresh
    " save all files on focus lost, ignoring warnings about untitled buffers
    autocmd FocusLost * silent! wa
    " close help only with q
    autocmd FileType help noremap <buffer> q :q<cr>
    " make quickfix windows take all the lower section of the screen
    " when there are multiple windows open
    autocmd FileType qf wincmd J
    autocmd FileType qf noremap <buffer> q :q<cr>

    " autocmd BufDelete * :call QuitIfLastBuffer()

    " Make current window more obvious by turning off/adjusting some features in non-current
    " windows.
    if exists('+winhighlight')
      autocmd BufEnter,FocusGained,VimEnter,WinEnter * if kiooss#autocmds#should_colorcolumn() | set winhighlight= | endif
      autocmd FocusLost,WinLeave * if kiooss#autocmds#should_colorcolumn() | set winhighlight=CursorLineNr:LineNr,IncSearch:ColorColumn,Normal:ColorColumn,NormalNC:ColorColumn,SignColumn:ColorColumn | endif
      if exists('+colorcolumn')
        autocmd BufEnter,FocusGained,VimEnter,WinEnter * if kiooss#autocmds#should_colorcolumn() | let &l:colorcolumn='+' . join(range(0, 254), ',+') | endif
      endif
    elseif exists('+colorcolumn')
      autocmd BufEnter,FocusGained,VimEnter,WinEnter * if kiooss#autocmds#should_colorcolumn() | let &l:colorcolumn='+' . join(range(0, 254), ',+') | endif
      autocmd FocusLost,WinLeave * if kiooss#autocmds#should_colorcolumn() | let &l:colorcolumn=join(range(1, 255), ',') | endif
    endif
endif
" }}}
