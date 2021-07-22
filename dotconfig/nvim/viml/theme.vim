" theme.vim---Theme settings.
" => Yang Yang
"=============================================================================

if has('gui_macvim')
  set macligatures
  set guifont=Fira\ Code:h12
endif

if has('gui_running')
  set background=dark
  set columns=150
  set lines=70
endif

let s:use_base16_theme = get(g:, 'use_base16_theme', 1)

if s:use_base16_theme && filereadable(expand('~/.vimrc_background'))
  source ~/.vimrc_background
else
  set background=dark
  " set background=light
  try
    " let g:falcon_airline = 1
    " let g:airline_theme = 'falcon'
    " colorscheme falcon

    " colorscheme onedark

    let g:gruvbox_contrast_dark = 'medium'
    " let g:gruvbox_contrast_light = 'medium'
    " let g:gruvbox_invert_tabline = 1
    " let g:gruvbox_improved_strings = 1
    let g:gruvbox_improved_warnings = 1
    " colorscheme gruvbox
    colorscheme happy_hacking
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
    colorscheme desert
    highlight ColorColumn guibg=Grey40
  endtry
endif

highlight User1 guibg=#333333 gui=bold,italic
highlight Comment gui=bold,italic
highlight Folded gui=bold,italic
highlight MatchParen cterm=bold ctermfg=red ctermbg=NONE gui=bold,reverse
highlight StartifyFile gui=bold,italic
" highlight NormalFloat cterm=bold,reverse gui=bold,reverse
highlight NormalFloat cterm=bold gui=bold
highlight TablineSel cterm=bold,reverse gui=bold,reverse

" make the highlighting of tabs and other non-text less annoying
highlight SpecialKey ctermfg=19 guifg=#333333

" highlight CocHighlightText gui=bold,reverse
" highlight CocHighlightText gui=bold,italic,reverse
highlight default link CocHighlightText User1

" background transparent
" highlight Normal guibg=none
" highlight NonText guibg=none
