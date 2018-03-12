" dein configurations.

let g:dein#install_progress_type = 'echo'
" let g:dein#enable_notification = 1
" let g:dein#notification_icon = '~/.vim/signs/warn.png'
let g:dein#install_max_processes = 32
let g:dein#install_log_filename = $VARPATH.'/dein.log'
let s:path = expand('$CACHE/dein')

if !dein#load_state(s:path)
  finish
endif

" Note: It executes ":filetype off" automatically.
call dein#begin(s:path, expand('<sfile>'))

call dein#load_toml(g:Config_Main_Home . '/dein.toml', {'lazy': 0})
call dein#load_toml(g:Config_Main_Home . '/deinlazy.toml', {'lazy' : 1})
if has('nvim')
  call dein#load_toml(g:Config_Main_Home . '/deineo.toml', {})
endif
call dein#load_toml(g:Config_Main_Home . '/deinft.toml')

if dein#tap('deoplete.nvim') && has('nvim')
  call dein#disable('neocomplete.vim')
endif

call dein#end()
call dein#save_state()

if !has('vim_starting') && dein#check_install()
  " Installation check.
  call dein#install()
endif