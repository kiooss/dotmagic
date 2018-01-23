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
