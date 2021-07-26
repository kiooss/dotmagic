let g:ale_sign_column_always = 1
" let g:ale_set_quickfix = 1
let g:ale_lint_delay = 1000
let g:ale_lint_on_text_changed = 'normal'
let g:ale_lint_on_enter = 1
let g:ale_lint_on_save = 1
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
" let g:ale_vim_vint_show_style_issues = 0

" let g:ale_linter_aliases = {
"       \   'javascript.jsx': 'javascript',
"       \   'jsx': 'javascript'
"       \}

let g:ale_linters = {
      \   'php': [],
      \   'javascript': [],
      \   'typescript': [],
      \   'ruby': [],
      \   'vim': ['vint'],
      \   'eruby': [],
      \}
" let g:ale_linters = {
"       \   'rust': [],
"       \   'go': [],
"       \   'vue': [],
"       \   'objcpp': [],
"       \   'c': [],
"       \   'java': [],
"       \   'javascript': [],
"       \   'dart': [],
"       \   'tex': [],
"       \   'wxss': [],
"       \   'vim': ['vint'],
"       \   'markdown': [],
"       \   'python': [],
"       \   'html': [],
"       \   'ruby': [],
"       \   'scss': [],
"       \   'css': [],
"       \   'typescript': [],
"       \   'json': [],
"       \   'swift': ['swiftlint'],
"       \}
let g:ale_fixers = {
      \ 'javascript': ['eslint'],
      \ 'vue': ['eslint'],
      \ 'typescript': ['eslint'],
      \ 'json': ['fixjson'],
      \ 'ruby': ['rubocop']
      \}

let g:ale_pattern_options = {
      \ '\.min\.js$': {'ale_enabled': 0},
      \ '\.min\.css$': {'ale_enabled': 0},
      \ '\.txt$': {'ale_enabled': 0},
      \ '.*gems/.*\.rb$': {'ale_enabled': 0},
      \ 'Vagrantfile$': {'ale_enabled': 0},
      \}

let g:ale_sign_error = '✗' " u2717
let g:ale_sign_warning = '⚠'
let g:ale_sign_info = 'ℹ'
let g:ale_sign_style_error = '>>'
let g:ale_sign_style_warning = '--'

if get(g:, 'enable_patched_font', 0)
  let g:ale_statusline_format = ['✖ %d', '⚠ %d', '⬥ ok']
endif

nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)
nmap <localleader>j <Plug>(ale_fix)
nmap <localleader>d <Plug>(ale_detail)
