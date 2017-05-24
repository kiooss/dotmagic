"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Customize
" vim: set fdm=marker fdc=1:
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" show multi byte space {{{
"highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=darkgray
"match ZenkakuSpace /　/
function! ZenkakuSpace()
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

" HiInterestingWord {{{
function! HiInterestingWord(n)
    " Save our location.
    normal! mz

    " Yank the current word into the z register.
    normal! "zyiw

    " Calculate an arbitrary match ID.  Hopefully nothing else is using it.
    let mid = 86750 + a:n

    " Clear existing matches, but don't worry if they don't exist.
    silent! call matchdelete(mid)

    " Construct a literal pattern that has to match at boundaries.
    let pat = '\V\<' . escape(@z, '\') . '\>'

    " Actually match the words.
    call matchadd("InterestingWord" . a:n, pat, 1, mid)

    " Move back to our original location.
    normal! `z
endfunction

nnoremap <silent> <leader>1 :call HiInterestingWord(1)<cr>
nnoremap <silent> <leader>2 :call HiInterestingWord(2)<cr>
nnoremap <silent> <leader>3 :call HiInterestingWord(3)<cr>
nnoremap <silent> <leader>4 :call HiInterestingWord(4)<cr>
nnoremap <silent> <leader>5 :call HiInterestingWord(5)<cr>
nnoremap <silent> <leader>6 :call HiInterestingWord(6)<cr>

hi def InterestingWord1 guifg=#000000 ctermfg=16 guibg=#ffa724 ctermbg=214
hi def InterestingWord2 guifg=#000000 ctermfg=16 guibg=#aeee00 ctermbg=154
hi def InterestingWord3 guifg=#000000 ctermfg=16 guibg=#8cffba ctermbg=121
hi def InterestingWord4 guifg=#000000 ctermfg=16 guibg=#b88853 ctermbg=137
hi def InterestingWord5 guifg=#000000 ctermfg=16 guibg=#ff9eb8 ctermbg=211
hi def InterestingWord6 guifg=#000000 ctermfg=16 guibg=#ff2c4b ctermbg=195
"}}}

" HtmlUnEscape {{{
function! HtmlUnEscape()
  silent s/&lt;/</eg
  silent s/&gt;/>/eg
  silent s/&amp;/\&/eg
endfunction

" nnoremap <silent> <leader>us :call HtmlUnEscape()<cr>
"}}}

" AlignPHPMap {{{
" format array
" function! AlignPHPMap() range
"      let sep = '=>'
"      let firstline = a:firstline
"      let lastline = a:lastline
"      let lines = {}
"      for lineno in range(firstline, lastline)
"           let lines[lineno] = match(getline(lineno), '\s*' . sep)
"      endfor
"      let maxLen = max(lines) + 1
"      for lineno in range(firstline, lastline)
"           if lines[lineno] != -1
"                let spaces = repeat(' ', maxLen - lines[lineno])
"                call setline(lineno, substitute(getline(lineno), '\s*' . sep . '\s*', spaces . sep . ' ', ''))
"           endif
"      endfor
" endfunction
"
" noremap <Leader>=> :call AlignPHPMap()<CR>
"
" " format =
" function! AlignPHPAssign() range
"      let sep = '='
"      let firstline = a:firstline
"      let lastline = a:lastline
"      let lines = {}
"      for lineno in range(firstline, lastline)
"           let lines[lineno] = match(getline(lineno), '\s*' . sep)
"      endfor
"      let maxLen = max(lines) + 1
"      for lineno in range(firstline, lastline)
"           if lines[lineno] != -1
"                let spaces = repeat(' ', maxLen - lines[lineno])
"                call setline(lineno, substitute(getline(lineno), '\s*' . sep . '\s*', spaces . sep . ' ', ''))
"           endif
"      endfor
" endfunction
"
" noremap <Leader>== :call AlignPHPAssign()<CR>
"}}}
