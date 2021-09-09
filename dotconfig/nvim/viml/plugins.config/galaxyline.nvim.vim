" function! ConfigStatusLine()
"   lua require('plugins.galaxyline')
" endfunction

" augroup status_line_init
"   autocmd!
"   autocmd VimEnter * call ConfigStatusLine()
" augroup END
lua require('plugins.galaxyline')
