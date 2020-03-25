function! SetupCommandAbbrs(from, to)
  exec 'cnoreabbrev <expr> '.a:from
        \ .' ((getcmdtype() ==# ":" && getcmdline() ==# "'.a:from.'")'
        \ .'? ("'.a:to.'") : ("'.a:from.'"))'
endfunction

" Use C to open coc config
call SetupCommandAbbrs('C', 'CocConfig')
call SetupCommandAbbrs('L', 'CocList')
call SetupCommandAbbrs('S', 'CocSearch')
call SetupCommandAbbrs('W', 'SudaWrite')
