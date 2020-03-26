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

setlocal iskeyword+=!
setlocal iskeyword+=?

let g:ruby_operators                 = 1
let g:ruby_space_errors              = 1
let g:rubycomplete_buffer_loading    = 1
let g:rubycomplete_classes_in_global = 1
let g:rubycomplete_rails             = 1

let &cpo = s:save_cpo
