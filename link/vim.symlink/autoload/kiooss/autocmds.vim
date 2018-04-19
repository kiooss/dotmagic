let g:KioossColorColumnBlacklist = ['diff', 'fugitiveblame', 'undotree', 'nerdtree', 'qf']

function! kiooss#autocmds#should_colorcolumn() abort
  return index(g:KioossColorColumnBlacklist, &filetype) == -1
endfunction

function! kiooss#autocmds#vim_refresh() abort
  source $MYVIMRC
  if exists(':AirlineRefresh')
    AirlineRefresh
  endif
  call kiooss#autocmds#base16_customize()
endfunction

function! kiooss#autocmds#check_clipper() abort
  let output = system('netstat -lx | grep .clipper.sock')
  if output !~# 'LISTENING'
    echom  '.clipper.sock is not active!'
  endif
endfunction
