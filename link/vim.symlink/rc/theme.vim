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

let s:use_base16_theme = get(g:, 'use_base16_theme', 1)
if has('syntax')
  if s:use_base16_theme
    autocmd MyAutoCmd ColorScheme * call kiooss#autocmds#base16_customize()
  else
    autocmd MyAutoCmd ColorScheme *
          \ highlight Comment gui=bold,italic
          \ | highlight Folded gui=bold,italic
          \ | highlight MatchParen cterm=bold ctermfg=red ctermbg=NONE gui=bold guifg=red guibg=NONE
  endif
endif

" highlight conflicts
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'

if s:use_base16_theme && filereadable(expand('~/.vimrc_background'))
  let g:airline_theme='base16_flat'
  let g:base16colorspace=256
  source ~/.vimrc_background
else
  " set background=dark
  try
    let g:airline_theme='ayu'
    let ayucolor="mirage" " for mirage version of theme
    colorscheme ayu
  catch
  endtry
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
