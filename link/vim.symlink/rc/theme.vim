"=============================================================================
" theme.vim---Theme settings.
" => Yang Yang
"=============================================================================

if has('gui_macvim')
  set guifont=Droid\ Sans\ Mono\ for\ Powerline\ Nerd\ Font\ Complete\:h14
endif

if has('gui_running')
  set background=dark
  set columns=150
  set lines=70
endif

" highlight conflicts
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'

" set background=light
" set background=dark

" hard|medium|soft
" let g:gruvbox_contrast_dark="hard"
" let g:gruvbox_contrast_light="hard"
" colorscheme gruvbox

if filereadable(expand('~/.vimrc_background'))
  let g:airline_theme='base16_flat'
  let g:base16colorspace=256
  source ~/.vimrc_background
else
  set background=dark
  let g:airline_theme='hybrid'
  colorscheme gruvbox
endif

" let ayucolor="light"  " for light version of theme
" let ayucolor="mirage" " for mirage version of theme
" let ayucolor="dark"   " for dark version of theme
" colorscheme ayu

" colorscheme srcery
" let g:solarized_visibility="low"
" let g:solarized_termtrans=1
" colorscheme solarized8_dark_high
" colorscheme solarized8_dark

" colorscheme molokai
" colorscheme PaperColor

" colorscheme hybrid_material
" colorscheme monrovia

" Airline Theme
" let g:airline_theme='luna'
" let g:airline_theme='powerlineish'
" let g:airline_theme='badwolf'
" let g:airline_theme='papercolor'
" let g:airline_theme='gruvbox'

if dein#tap('vim-airline') && dein#tap('vim-gutentags')
  call airline#parts#define_function('gutentags','gutentags#statusline')
  call airline#parts#define_condition('gutentags', 'exists("*gutentags#statusline")')
  let g:airline_section_gutter = airline#section#create(['%=', 'gutentags'])
endif
