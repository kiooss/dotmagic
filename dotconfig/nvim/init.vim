"=============================================================================
" init.vim --- Config Entry file for neovim
" => Yang Yang
"=============================================================================

scriptencoding utf-8

let s:script_path = expand('<sfile>:p:h')

let $VIMPATH = s:script_path

"---------------------------------------------------------------------------
" Loading configuration modules
let s:sourceList = [
      \ 'init',
      \ 'plugins',
      \ 'functions',
      \ 'commands',
      \ 'abbr',
      \ 'general',
      \ 'autocmds',
      \ 'mappings',
      \ 'neovim',
      \ 'plugin-config',
      \ 'theme',
      \]
for s:item in s:sourceList
  exec 'source ' . s:script_path . '/viml/' . s:item . '.vim'
endfor

unlet s:script_path
unlet s:sourceList

"---------------------------------------------------------------------------
set secure
