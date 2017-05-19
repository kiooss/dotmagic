" w0rp/ale {{{
let g:ale_set_quickfix = 1
let g:ale_statusline_format = ['⨉ %d', '⚠ %d', '⬥ ok']
let g:ale_linters = {
\   'php': ['php'],
\   'javascript': [],
\   'ruby': ['ruby'],
\}
" let g:ale_open_list = 1
" let g:ale_keep_list_window_open = 1
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'


" set statusline+=%{ALEGetStatusLine()}
" set statusline+=%*

nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)
" }}}
