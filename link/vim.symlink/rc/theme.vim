"=============================================================================
" theme.vim---Theme settings.
" => Yang Yang
"=============================================================================

if has('gui_macvim')
  set macligatures
  set guifont=Fira\ Code:h12
  " set guifont=Droid\ Sans\ Mono\ for\ Powerline\ Nerd\ Font\ Complete\:h14
endif

if has('gui_running')
  set background=dark
  set columns=150
  set lines=70
endif

if has('syntax')
  autocmd MyAutoCmd ColorScheme *
        \ highlight Comment gui=bold,italic
        \ | highlight Folded gui=bold,italic
        \ | highlight MatchParen cterm=bold ctermfg=red ctermbg=NONE gui=bold,reverse
        \ | highlight StartifyFile gui=bold,italic
endif

let s:use_base16_theme = get(g:, 'use_base16_theme', 1)

if s:use_base16_theme && filereadable(expand('~/.vimrc_background'))
  source ~/.vimrc_background
else
  set background=dark
  " set background=light
  try
    colorscheme onedark
    " let g:gruvbox_contrast_dark = 'medium'
    " let g:gruvbox_invert_tabline = 1
    " let g:gruvbox_improved_strings = 1
    " let g:gruvbox_improved_warnings = 1
    " colorscheme gruvbox
    """ gotham
    " let g:airline_theme='gotham'
    " colorscheme gotham
    """ neodark
    " let g:airline_theme='neodark'
    " colorscheme neodark
    """ snow
    " set background=dark
    " let g:airline_theme='snow_dark'
    " colorscheme snow
    """ palenight
    " set background=dark
    " let g:airline_theme='onedark'
    " let g:palenight_terminal_italics=1
    " colorscheme palenight
    """ ayu
    " let g:airline_theme='ayu'
    " let ayucolor='light'  " for light version of theme
    " let ayucolor='mirage' " for mirage version of theme
    " let ayucolor='dark'   " for dark version of theme
    " colorscheme ayu
  catch
  endtry
endif


" colorscheme srcery
" let g:solarized_visibility="low"
" let g:solarized_termtrans=1
" colorscheme solarized8_dark_high
" colorscheme solarized8_dark
