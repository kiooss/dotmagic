scriptencoding utf-8

let g:airline_powerline_fonts=1
let g:airline_left_sep=''
let g:airline_right_sep=''
let g:airline_left_alt_sep = "\ue0c1"
let g:airline_right_alt_sep = "\ue0c3"
" let g:airline_left_sep = ' '
" let g:airline_left_alt_sep = '|'
" let g:airline_right_sep = ' '
" let g:airline_right_alt_sep = '|'

let g:airline_skip_empty_sections = 1

" extensions
let g:airline#extensions#coc#enabled = 1
" let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#hunks#enabled = 1
let g:airline#extensions#ale#enabled = 1
let g:airline#extensions#fugitiveline#enabled = 1

" tabline
let g:airline#extensions#tabline#show_tab_nr = 1
let g:airline#extensions#tabline#tab_nr_type= 2
let g:airline#extensions#tabline#show_tab_type = 1
let g:airline#extensions#tabline#buffers_label = "\ufb18"
let g:airline#extensions#tabline#tabs_label = "\uf9e8"
let g:airline#extensions#tabline#buffer_idx_mode = 1

let g:airline#extensions#coc#error_symbol = '✗:'
let g:airline#extensions#coc#warning_symbol = '⚠ :'
let g:airline#extensions#ale#checking_symbol = '⚙  checking...'

" let g:airline#extensions#coc#error_symbol = '✗:'
" let g:airline#extensions#coc#warning_symbol = '⚠ :'
" let airline#extensions#coc#stl_format_err = '%E{[%e(#%fe)]}'
" let airline#extensions#coc#stl_format_warn = '%W{[%w(#%fw)]}'

function! CocCurrentFunction()
  return get(b:, 'coc_current_function', '')
endfunction

" call airline#parts#define_function('current_function', 'CocCurrentFunction')
" call airline#parts#define_function('status_diagnostic', 'StatusDiagnostic')
" let g:airline_section_c = airline#section#create(['%<', 'file', ' ', 'readonly', ' ', 'status_diagnostic', ' ', 'current_function'])

" mappings
" nmap <leader>1 <Plug>AirlineSelectTab1
" nmap <leader>2 <Plug>AirlineSelectTab2
" nmap <leader>3 <Plug>AirlineSelectTab3
" nmap <leader>4 <Plug>AirlineSelectTab4
" nmap <leader>5 <Plug>AirlineSelectTab5
" nmap <leader>6 <Plug>AirlineSelectTab6
" nmap <leader>7 <Plug>AirlineSelectTab7
" nmap <leader>8 <Plug>AirlineSelectTab8
" nmap <leader>9 <Plug>AirlineSelectTab9
