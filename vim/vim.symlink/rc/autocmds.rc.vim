"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Autocmd settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" {{{ file type specific settings
if has('autocmd') && !exists('autocommands_loaded')
    let autocommands_loaded = 1

    " php
    autocmd FileType php set dictionary+=~/.vim/php.dict

    autocmd FileType php setlocal ts=4 sts=4 sw=4 expandtab
    autocmd FileType ruby setlocal ts=2 sts=2 sw=2 expandtab
    autocmd FileType vim setlocal ts=2 sts=2 sw=2 expandtab
    autocmd FileType coffee setlocal ts=2 sts=2 sw=2 expandtab
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
    " autocmd BufWritePost .vimrc source %
    " autocmd BufWritePost .vimrc.local source %
    autocmd BufWritePost .vimrc,vimrc,*.rc.vim,*.toml source $MYVIMRC | AirlineRefresh
    " save all files on focus lost, ignoring warnings about untitled buffers
    autocmd FocusLost * silent! wa
    " close help only with
    autocmd FileType help noremap <buffer> q :q<cr>

    " autocmd BufDelete * :call QuitIfLastBuffer()
endif
" }}}
