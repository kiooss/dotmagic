"=============================================================================
" plugins.vim --- load plugins by layer
" => Yang Yang
"=============================================================================

scriptencoding utf-8

if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

let s:script_path = expand('<sfile>:p:h')

function! s:source(layer) abort
  execute 'source ' . s:script_path . '/layer/' . a:layer . '.vim'
endfunction

call plug#begin(s:script_path . '/plugins')

call s:source('coc')
call s:source('syntax')
call s:source('enhance')
call s:source('text-operate')
call s:source('util')
call s:source('style')
call s:source('lazy')

call plug#end()

" Free memory
delfunction s:source
unlet s:script_path
