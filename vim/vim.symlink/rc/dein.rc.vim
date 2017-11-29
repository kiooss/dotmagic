" dein configurations.

" let g:dein#install_progress_type = 'title'
" let g:dein#enable_notification = 1
" let g:dein#notification_icon = '~/.vim/signs/warn.png'
let g:dein#install_log_filename = '~/dein.log'

let s:path = expand('$CACHE/dein')
if dein#load_state(s:path)
  " Note: It executes ":filetype off" automatically.
  call dein#begin(s:path, expand('<sfile>'))

  call dein#load_toml('~/.vim/rc/dein.toml', {'lazy': 0})
  call dein#load_toml('~/.vim/rc/deinlazy.toml', {'lazy' : 1})
  if has('nvim')
    call dein#load_toml('~/.vim/rc/deineo.toml', {})
  endif

  if dein#tap('deoplete.nvim') && has('nvim')
    call dein#disable('neocomplete.vim')
  endif

  call dein#end()
  call dein#save_state()
endif

" Required:
filetype plugin indent on
syntax enable

" If you want to install not installed plugins on startup.
"if dein#check_install()
"  call dein#install()
"endif

if !has('vim_starting') && dein#check_install()
  " Installation check.
  call dein#install()
endif
