let g:KioossColorColumnBlacklist = ['diff', 'fugitiveblame', 'undotree', 'nerdtree', 'qf']

function! kiooss#autocmds#should_colorcolumn() abort
  return index(g:KioossColorColumnBlacklist, &filetype) == -1
endfunction

function! kiooss#autocmds#base16_customize() abort
  call Base16hi("Comment", g:base16_gui03, "", g:base16_cterm03, "", "bold,italic", "")
  call Base16hi("Folded", g:base16_gui03, g:base16_gui01, g:base16_cterm03, g:base16_cterm01, "bold,italic", "")
  if g:colors_name ==# 'base16-github'
    call Base16hi("StartifyFile", g:base16_gui09, "", g:base16_cterm09, "", "bold,italic", "")
  else
    call Base16hi("StartifyFile", g:base16_gui07, "", g:base16_cterm07, "", "bold,italic", "")
  endif
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
    echo output
  endif
endfunction
