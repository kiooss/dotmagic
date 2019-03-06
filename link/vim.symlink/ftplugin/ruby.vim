let s:save_cpo = &cpo
set cpo&vim

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' | '
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= 'setl modeline<'

" set indent.
setlocal shiftwidth=2 softtabstop=2 tabstop=2

let g:ruby_operators                 = 1
let g:ruby_space_errors              = 1
let g:rubycomplete_buffer_loading    = 1
let g:rubycomplete_classes_in_global = 1
let g:rubycomplete_rails             = 1

" LanguageClient-neovim
nnoremap <Leader>mm :call LanguageClient_contextMenu()<CR>
nnoremap <silent> <Leader>K :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent> <Leader>o :call LanguageClient#textDocument_definition()<CR>
nnoremap <silent> <Leader>r :call LanguageClient#textDocument_rename()<CR>


let &cpo = s:save_cpo
