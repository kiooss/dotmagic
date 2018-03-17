"==============================================================================
" commands.vim---define commands.
" => Yang Yang
"==============================================================================

" ----------------------------------------------------------------------------
" :Root | Change directory to the root of the Git repository
" ----------------------------------------------------------------------------
function! s:root() "{{{
  let root = systemlist('git rev-parse --show-toplevel')[0]
  if v:shell_error
    echo 'Not in git repo'
  else
    execute 'lcd' root
    echo 'Changed directory to: '.root
  endif
endfunction
command! Root call s:root() "}}}

" ----------------------------------------------------------------------------
" Profile
" ----------------------------------------------------------------------------
function! s:profile(bang) "{{{
  if a:bang
    profile pause
    noautocmd qall
  else
    profile start /tmp/profile.log
    profile func *
    profile file *
  endif
endfunction
command! -bang Profile call s:profile(<bang>0) "}}}

command! GetChar call kiooss#debug#getchar()
command! CleanPlugins call map(dein#check_clean(), "delete(v:val, 'rf')")
