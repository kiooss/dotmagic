"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugin settings
" vim: set fdm=marker fdc=1:
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" supertab {{{

"let g:SuperTabMappingForward="<tab>"
"let g:SuperTabMappingBackward="<S-Tab>"
" let g:SuperTabDefaultCompletionType = "<c-n>"
let g:SuperTabDefaultCompletionType = "context"
let g:SuperTabClosePreviewOnPopupClose = 1
" }}}

" snipMate {{{
" let g:snipMate = {}
" let g:snipMate.scope_aliases = {}
" let g:snipMate.scope_aliases['ruby'] = 'ruby,rails'
"
" imap <C-J> <Plug>snipMateNextOrTrigger
" smap <C-J> <Plug>snipMateNextOrTrigger
" }}}

" vim-php-namespace {{{
function! IPhpInsertUse()
    call PhpInsertUse()
    call feedkeys('a',  'n')
endfunction
" autocmd FileType php inoremap <Leader>u <Esc>:call IPhpInsertUse()<CR>
autocmd FileType php noremap <Leader>u :call PhpInsertUse()<CR>

function! IPhpExpandClass()
    call PhpExpandClass()
    call feedkeys('a', 'n')
endfunction
" autocmd FileType php inoremap <Leader>e <Esc>:call IPhpExpandClass()<CR>
autocmd FileType php noremap <Leader>e :call PhpExpandClass()<CR>

" autocmd FileType php inoremap <Leader>s <Esc>:call PhpSortUse()<CR>
autocmd FileType php noremap <Leader>s :call PhpSortUse()<CR>
""" }}}

" Vim-php-cs-fixer {{{
" If php-cs-fixer is in $PATH, you don't need to define line below
" let g:php_cs_fixer_path = "~/php-cs-fixer.phar" " define the path to the php-cs-fixer.phar
" let g:php_cs_fixer_level = "symfony"              " which level ?
let g:php_cs_fixer_level = "all"              " which level ?
" let g:php_cs_fixer_config = "default"             " configuration
"let g:php_cs_fixer_config_file = '.php_cs'       " configuration file
" let g:php_cs_fixer_php_path = "php"               " Path to PHP
" If you want to define specific fixers:
"let g:php_cs_fixer_fixers_list = "linefeed,short_tag,indentation"
let g:php_cs_fixer_enable_default_mapping = 1     " Enable the mapping by default (<leader>pcd)
let g:php_cs_fixer_dry_run = 0                    " Call command with dry-run option
let g:php_cs_fixer_verbose = 0                    " Return the output of command if 1, else an inline information.
""" }}}

" terryma/vim-multiple-cursors {{{
" Prevent conflict with Neocomplete
" Called once right before you start selecting multiple cursors
function! Multiple_cursors_before()
  if exists(':NeoCompleteLock')==2
    exe 'NeoCompleteLock'
  endif
endfunction

" Called once only when the multiple selection is canceled (default <Esc>)
function! Multiple_cursors_after()
  if exists(':NeoCompleteUnlock')==2
    exe 'NeoCompleteUnlock'
  endif
endfunction
" }}}

" benmills/vimux {{{
" Run the current file with rspec
map <Leader>rb :call VimuxRunCommand("clear; rspec " . bufname("%"))<CR>

" Prompt for a command to run
map <Leader>vp :VimuxPromptCommand<CR>

" Run last command executed by VimuxRunCommand
map <Leader>vl :VimuxRunLastCommand<CR>

" Inspect runner pane
map <Leader>vi :VimuxInspectRunner<CR>

" Close vim tmux runner opened by VimuxRunCommand
map <Leader>vq :VimuxCloseRunner<CR>

" Interrupt any command running in the runner pane
map <Leader>vx :VimuxInterruptRunner<CR>

" Zoom the runner pane (use <bind-key> z to restore runner pane)
map <Leader>vz :call VimuxZoomRunner()<CR>
" }}}

" vim-syntastic/syntastic {{{
" set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
" set statusline+=%*
"
" let g:syntastic_always_populate_loc_list = 1
" let g:syntastic_auto_loc_list = 1
" let g:syntastic_check_on_open = 1
" let g:syntastic_check_on_wq = 0
"
" let g:syntastic_php_checkers = ['php']
"}}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Customize
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
