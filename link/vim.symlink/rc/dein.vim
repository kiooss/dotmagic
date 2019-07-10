" dein configurations.

let g:dein#auto_recache = 1
let g:dein#install_progress_type = 'tabline'
" let g:dein#enable_notification = 1
let g:dein#install_max_processes = 32
let g:dein#install_log_filename = $VARPATH.'/dein.log'
let s:path = expand('$VARPATH/dein')
let s:config_path = expand('$VIMPATH/rc')

if !dein#load_state(s:path)
  finish
endif

let s:plugins_path = s:config_path . '/dein.toml'
let s:lazy_plugins_path = s:config_path . '/deinlazy.toml'
let s:ft_path = s:config_path . '/deinft.toml'

" Note: It executes ":filetype off" automatically.
call dein#begin(s:path, [
      \ expand('<sfile>'),
      \ s:plugins_path,
      \ s:lazy_plugins_path,
      \ s:ft_path
      \])

call dein#load_toml(s:plugins_path, {'lazy': 0})
call dein#load_toml(s:lazy_plugins_path, {'lazy' : 1})
call dein#load_toml(s:ft_path)

" disable some plugins temporary.
" call dein#disable('coc.nvim')

call dein#end()
call dein#save_state()

if !has('vim_starting') && dein#check_install()
  " Installation check.
  call dein#install()
endif
