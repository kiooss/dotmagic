let s:apis = {}

function! kiooss#api#import(name) abort
  if has_key(s:apis, a:name)
    return deepcopy(s:apis[a:name])
  endif
  let p = {}
  try
    let p = kiooss#api#{a:name}#get()
    let s:apis[a:name] = p
  catch /^Vim\%((\a\+)\)\=:E117/
  endtry
  return p
endfunction
