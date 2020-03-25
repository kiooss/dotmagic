let s:save_cpo = &cpo
set cpo&vim


if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' | '
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= 'setl modeline<'

" set indent.
setlocal shiftwidth=2 softtabstop=2

setlocal iskeyword+=:,#

vnoremap <buffer> <Leader>e "xy<C-u>:exe 'echo '.@x<CR>

" For gf.
let &l:path = join(map(split(&runtimepath, ','), 'v:val."/autoload"'), ',')
setlocal suffixesadd=.vim
setlocal includeexpr=fnamemodify(substitute(v:fname,'#','/','g'),':h')

let &cpo = s:save_cpo
