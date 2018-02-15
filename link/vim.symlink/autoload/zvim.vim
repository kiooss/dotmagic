" TODO

" format whole buffer and hold the cursor position.
function! zvim#format() abort
  let save_cursor = getpos('.')
  normal! gg=G
  call setpos('.', save_cursor)
endfunction
