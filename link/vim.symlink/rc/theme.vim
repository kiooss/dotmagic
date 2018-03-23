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
