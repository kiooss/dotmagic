let g:KioossColorColumnBlacklist = ['diff', 'fugitiveblame', 'undotree', 'nerdtree', 'qf']

function! kiooss#autocmds#should_colorcolumn() abort
  return index(g:KioossColorColumnBlacklist, &filetype) == -1
endfunction
