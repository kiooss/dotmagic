"=============================================================================
" init.vim--- Vim initialize config.
" => Yang Yang
"=============================================================================

" Set augroup.
augroup MyAutoCmd
  autocmd!
augroup END

" Use English interface.
language message C

if filereadable(expand('~/.vimrc.local'))
  execute 'source' expand('~/.vimrc.local')
endif

" Disable packpath
set packpath=

" Disable pre-bundled plugins
let g:loaded_2html_plugin       = 1
let g:loaded_getscript          = 1
let g:loaded_getscriptPlugin    = 1
" let g:loaded_gzip               = 1
let g:loaded_logiPat            = 1
" let g:loaded_matchit          = 1
" let g:loaded_matchparen       = 1
let g:loaded_netrwFileHandlers  = 1
let g:loaded_netrwPlugin        = 1
let g:loaded_netrwSettings      = 1
let g:loaded_rrhelper           = 1
let g:loaded_shada_plugin       = 1
let g:loaded_tar                = 1
let g:loaded_tarPlugin          = 1
let g:loaded_tutor_mode_plugin  = 1
let g:loaded_tutor_mode_plugin  = 1
let g:loaded_vimball            = 1
let g:loaded_vimballPlugin      = 1
let g:loaded_zip                = 1
let g:loaded_zipPlugin          = 1
" let g:loaded_man              = 1
" let g:loaded_spellfile_plugin = 1
" let g:loaded_python_provider  = 1

" disable Python 2 support
" let g:loaded_python_provider = 1

let $VARPATH = expand(($XDG_CACHE_HOME ? $XDG_CACHE_HOME : '~/.cache').'/vim')
let g:python_host_prog = $VARPATH.'/venv/neovim2/bin/python'
let g:python3_host_prog = $VARPATH.'/venv/neovim3/bin/python'
" let $NVIM_NODE_LOG_FILE='nvim-node.log'
" let $NVIM_NODE_LOG_LEVEL='warn'
