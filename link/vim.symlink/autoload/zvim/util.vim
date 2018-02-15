scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

function! zvim#util#source_rc(file) abort
  let abspath = resolve(expand(g:Config_Main_Home. '/' . a:file))
  if filereadable(abspath)
    execute 'source' fnameescape(abspath)
  endif
endf

let &cpo = s:save_cpo
unlet s:save_cpo
