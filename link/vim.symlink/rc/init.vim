"=============================================================================
" init.vim--- Vim initialize config.
" => Yang Yang
"=============================================================================

let s:is_windows = has('win32') || has('win64')

function! IsWindows() abort
  return s:is_windows
endfunction

function! IsMac() abort
  return !s:is_windows && !has('win32unix')
        \ && (has('mac') || has('macunix') || has('gui_macvim')
        \     || (!executable('xdg-open') && system('uname') =~? '^darwin'))
endfunction

" Setting of the encoding to use for a save and reading.
" Make it normal in UTF-8 in Unix.
if has('vim_starting') && &encoding !=# 'utf-8'
  if IsWindows() && !has('gui_running')
    set encoding=cp932
  else
    set encoding=utf-8
  endif
endif

" Build encodings.
let &fileencodings = join([
      \ 'ucs-bom', 'iso-2022-jp-3', 'utf-8', 'euc-jp', 'cp932'])

" Setting of terminal encoding.
if !has('gui_running') && IsWindows()
  " For system.
  set termencoding=cp932
endif

if has('multi_byte_ime')
  set iminsert=0 imsearch=0
endif

" Use English interface.
language message C

" Use <Leader> in global plugin.
let g:mapleader = "\<Space>"
" Use <LocalLeader> in filetype plugin.
let g:maplocalleader = ';'

" Release keymappings for plug-in.
nnoremap <Space>  <Nop>
xnoremap <Space>  <Nop>
nnoremap ,        <Nop>
xnoremap ,        <Nop>
nnoremap ;        <Nop>
xnoremap ;        <Nop>

if IsWindows()
  " Exchange path separator.
  set shellslash
endif

" Ensure cache directory "{{{
if ! isdirectory(expand($VARPATH))
  call mkdir(expand($VARPATH), 'p')
endif

if filereadable(expand('~/.secret_vimrc'))
  execute 'source' expand('~/.secret_vimrc')
endif

" Load dein.
if g:load_plugins
  let s:dein_dir = finddir('dein.vim', '.;')
  if s:dein_dir != '' || &runtimepath !~ '/dein.vim'
    if s:dein_dir == '' && &runtimepath !~ '/dein.vim'
      let s:dein_dir = expand('$VARPATH/dein')
            \. '/repos/github.com/Shougo/dein.vim'
      if !isdirectory(s:dein_dir)
        execute '!git clone https://github.com/Shougo/dein.vim' s:dein_dir
      endif
    endif
    execute 'set runtimepath^=' . substitute(
          \ fnamemodify(s:dein_dir, ':p') , '/$', '', '')
  endif
endif

" Disable packpath
set packpath=

if has('gui_running')
  " Disable menu.vim
  set guioptions=Mc
else
  " Enable true color
  if has('termguicolors')
    set termguicolors
  else
    " Explicitly tell vim that the terminal supports 256 colors
    set t_Co=256
  endif
endif

" Disable pre-bundled plugins
let g:loaded_2html_plugin       = 1
let g:loaded_getscript          = 1
let g:loaded_getscriptPlugin    = 1
let g:loaded_gzip               = 1
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

if has('nvim')
  let g:python_host_skip_check = 1
  let g:python3_host_skip_check = 1
  " Search and use environments specifically made for Neovim.
  if isdirectory($VARPATH.'/venv/neovim2')
    let g:python_host_prog = $VARPATH.'/venv/neovim2/bin/python'
  endif
  if isdirectory($VARPATH.'/venv/neovim3')
    let g:python3_host_prog = $VARPATH.'/venv/neovim3/bin/python'
  endif
  " move to ~/.secret_vimrc
  " let g:ruby_host_prog = '~/.rbenv/versions/2.5.1/bin/neovim-ruby-host'
  " let $NVIM_NODE_LOG_FILE='nvim-node.log'
  " let $NVIM_NODE_LOG_LEVEL='warn'
endif
