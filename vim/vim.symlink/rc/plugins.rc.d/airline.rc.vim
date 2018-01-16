" airline {{{
set ttimeoutlen=50

let g:airline_powerline_fonts=1
let g:airline_left_sep=''
let g:airline_right_sep=''
" let g:airline_theme='luna'
"let g:airline_theme='powerlineish'
" let g:airline_theme='badwolf'
" let g:airline_theme='papercolor'
" let g:airline_theme='gruvbox'

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#hunks#enabled = 1
let g:airline#extensions#ale#enabled = 1

" call airline#parts#define_function('ALE', 'ALEGetStatusLine')
" call airline#parts#define_condition('ALE', 'exists("*ALEGetStatusLine")')
call airline#parts#define_function('gutentags','gutentags#statusline')
call airline#parts#define_condition('gutentags', 'exists("*gutentags#statusline")')
" let g:airline_section_error = airline#section#create_right(['ALE', 'gutentags'])
let g:airline_section_gutter = airline#section#create(['%=', 'gutentags'])

""" }}}
