scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

function! zvim#util#previewWindowOpened() abort
  for nr in range(1, winnr('$'))
    if getwinvar(nr, "&pvw") == 1
      " found a preview
      return 1
    endif
  endfor
  return 0
endfun

let &cpo = s:save_cpo
unlet s:save_cpo
