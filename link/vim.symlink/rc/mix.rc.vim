"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Customize
" vim: set fdm=marker:
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" save in readonly mode
cnoreabbrev w!! w !sudo tee > /dev/null %

" open help in vertical split window
cnoreabbrev vh vert h

call airline#parts#define_function('gutentags','gutentags#statusline')
call airline#parts#define_condition('gutentags', 'exists("*gutentags#statusline")')
let g:airline_section_gutter = airline#section#create(['%=', 'gutentags'])

" show multi byte space {{{
"highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=darkgray
"match ZenkakuSpace /　/
function! ZenkakuSpace() abort
    highlight ZenkakuSpace cterm=reverse ctermfg=DarkMagenta gui=reverse guifg=DarkMagenta
endfunction

if has('syntax')
    augroup ZenkakuSpace
        autocmd!
        autocmd ColorScheme       * call ZenkakuSpace()
        autocmd VimEnter,WinEnter * match ZenkakuSpace /　/
    augroup END
    call ZenkakuSpace()
endif
" }}}

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
