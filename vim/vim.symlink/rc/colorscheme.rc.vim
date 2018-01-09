" set background=light
" set background=dark

" hard|medium|soft
" let g:gruvbox_contrast_dark="hard"
" let g:gruvbox_contrast_light="hard"
" colorscheme gruvbox

if filereadable(expand("~/.vimrc_background"))
  let base16colorspace=256
  source ~/.vimrc_background
else
  set background=dark
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
let g:airline_theme='hybrid'
" let g:airline_theme='papercolor'
" let g:airline_theme='gruvbox'
