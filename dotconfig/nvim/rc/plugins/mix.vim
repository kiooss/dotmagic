"==============================================================================
" mix.vim---Mixed plugin settings.
" => Yang Yang
" vim: set ts=2 sw=2 tw=80 et fdl=0:
"==============================================================================

" FZF {{{
if dein#tap('fzf.vim')
  if has('nvim') || has('gui_running')
    let $FZF_DEFAULT_OPTS .= ' --inline-info'
  endif

  " Hide statusline of terminal buffer
  autocmd! FileType fzf
  autocmd  FileType fzf set laststatus=0 noshowmode noruler
    \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler

  let g:fzf_colors =
  \ { 'fg':      ['fg', 'Normal'],
    \ 'bg':      ['bg', 'Normal'],
    \ 'hl':      ['fg', 'Comment'],
    \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
    \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
    \ 'hl+':     ['fg', 'Statement'],
    \ 'info':    ['fg', 'PreProc'],
    \ 'border':  ['fg', 'Ignore'],
    \ 'prompt':  ['fg', 'Conditional'],
    \ 'pointer': ['fg', 'Exception'],
    \ 'marker':  ['fg', 'Keyword'],
    \ 'spinner': ['fg', 'Label'],
    \ 'header':  ['fg', 'Comment'] }

  command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

  command! -bang -nargs=? -complete=dir GFiles
    \ call fzf#vim#gitfiles(<q-args>, fzf#vim#with_preview(), <bang>0)

  " Ag match only file content, but not file name.
  command! -bang -nargs=* GrepWord
    \ call fzf#vim#ag(<q-args>, {'options': '--delimiter : --nth 4..'}, <bang>0)

  command! -bang -nargs=+ -complete=dir Rag call fzf#vim#ag_raw(<q-args>, {'options': '--delimiter : --nth 4..'}, <bang>0)

  nnoremap <silent> <expr> <C-p> (expand('%') =~ 'NERD_tree' ? "\<c-w>\<c-w>" : '').":GFiles\<cr>"
  nnoremap <silent> <Leader>f :GFiles --exclude-standard --cached --others<CR>
  nnoremap <silent> <Leader>F :Files<CR>
  nnoremap <silent> <Leader>bc :BCommits<CR>
  nnoremap <silent> <Leader>; :Lines<CR>
  nnoremap <silent> <Leader>g :GrepWord<CR>
  xnoremap <silent> <Leader>g y:GrepWord <C-R>"<CR>
  nnoremap <silent> <Leader>ag :Ag <C-R><C-W><CR>
  nnoremap <silent> <Leader>AG :Ag <C-R><C-A><CR>

  inoremap <expr> <c-x><c-t> fzf#complete('tmuxwords.rb --all-but-current --scroll 500 --min 5')

endif
"}}}

" Startify {{{
if dein#tap('vim-startify')
  " autocmd User Startified doautocmd ColorScheme
  autocmd User Startified for key in ['b','s','t','v'] | exe 'nunmap <buffer>' key | endfor
  " let g:startify_change_to_dir       = 1
  let g:startify_change_to_vcs_root  = 1
  let g:startify_update_oldfiles     = 1
  let g:startify_fortune_use_unicode = 1
  let g:startify_session_dir = '~/.cache/vim/sessions'
  " let g:startify_custom_header =
  "       \ map(split(system('fortune | cowsay -f dragon-and-cow'), '\n'), '"   ". v:val')
  let g:startify_lists = [
        \ { 'type': 'sessions',  'header': ['   ❐ SESSIONS']       },
        \ { 'type': 'dir',       'header': ['    MRU '. getcwd()] },
        \ { 'type': 'files',     'header': ['    MRU']            },
        \ { 'type': 'bookmarks', 'header': ['    BOOKMARKS']      },
        \ { 'type': 'commands',  'header': ['   גּ COMMANDS']       },
        \ ]
  let g:startify_bookmarks = [
          \ { 'tc': '~/.tmux.conf' },
          \ { 'de':  g:dein#install_log_filename },
          \ ]
  let g:startify_commands = [
      \ { 'c1': ['Vim Reference', 'h ref'] },
      \ { 'c2': ['Vim CheckHealth', 'CheckHealth'] },
      \ { 'c3': ['Dein recache rtp', 'call dein#recache_runtimepath()'] },
      \ { 'c4': ['Update plugins', 'call dein#update()'] },
      \ ]
  let g:startify_skiplist = [
      \ 'COMMIT_EDITMSG',
      \ '.git/*',
      \ 'runtime/doc/.*\.txt',
      \ 'bundle/.*/doc/.*\.txt',
      \ 'plugged/.*/doc/.*\.txt',
      \ 'dein/doc/.*\.txt',
      \ escape(fnamemodify(resolve($VIMRUNTIME), ':p'), '\') .'doc/.*\.txt',
      \ ]

  if get(g:, 'enable_patched_font', 0)
    function! StartifyEntryFormat()
      return 'WebDevIconsGetFileTypeSymbol(absolute_path) ." ". entry_path'
    endfunction
  endif
endif
" }}}

" vim-airline {{{
if dein#tap('vim-airline')
  if get(g:, 'enable_patched_font', 0)
    let g:airline_powerline_fonts=1
    let g:airline_left_sep=''
    let g:airline_right_sep=''
    let g:airline_left_alt_sep = "\ue0c1"
    let g:airline_right_alt_sep = "\ue0c3"
  endif
  " let g:airline_left_sep = ' '
  " let g:airline_left_alt_sep = '|'
  " let g:airline_right_sep = ' '
  " let g:airline_right_alt_sep = '|'

  let g:airline_skip_empty_sections = 1

  " extensions
  let g:airline#extensions#coc#enabled = 1
  let g:airline#extensions#tabline#enabled = 1
  let g:airline#extensions#hunks#enabled = 1
  let g:airline#extensions#ale#enabled = 1
  let g:airline#extensions#fugitiveline#enabled = 1

  " tabline
  let g:airline#extensions#tabline#show_tab_nr = 1
  let g:airline#extensions#tabline#tab_nr_type= 2
  let g:airline#extensions#tabline#show_tab_type = 1
  let g:airline#extensions#tabline#buffers_label = "\ufb18"
  let g:airline#extensions#tabline#tabs_label = "\uf9e8"
  let g:airline#extensions#tabline#buffer_idx_mode = 1

  let g:airline#extensions#coc#error_symbol = '✗:'
  let g:airline#extensions#coc#warning_symbol = '⚠ :'
  let g:airline#extensions#ale#checking_symbol = '⚙  checking...'

  " let g:airline#extensions#coc#error_symbol = '✗:'
  " let g:airline#extensions#coc#warning_symbol = '⚠ :'
  " let airline#extensions#coc#stl_format_err = '%E{[%e(#%fe)]}'
  " let airline#extensions#coc#stl_format_warn = '%W{[%w(#%fw)]}'

  function! CocCurrentFunction()
      return get(b:, 'coc_current_function', '')
  endfunction

  call airline#parts#define_function('current_function', 'CocCurrentFunction')
  call airline#parts#define_function('status_diagnostic', 'StatusDiagnostic')
  let g:airline_section_c = airline#section#create(['%<', 'file', ' ', 'readonly', ' ', 'status_diagnostic', ' ', 'current_function'])

  " mappings
  nmap <leader>1 <Plug>AirlineSelectTab1
  nmap <leader>2 <Plug>AirlineSelectTab2
  nmap <leader>3 <Plug>AirlineSelectTab3
  nmap <leader>4 <Plug>AirlineSelectTab4
  nmap <leader>5 <Plug>AirlineSelectTab5
  nmap <leader>6 <Plug>AirlineSelectTab6
  nmap <leader>7 <Plug>AirlineSelectTab7
  nmap <leader>8 <Plug>AirlineSelectTab8
  nmap <leader>9 <Plug>AirlineSelectTab9
endif
" }}}

" ale {{{
if dein#tap('ale')
  let g:ale_sign_column_always = 1
  " let g:ale_set_quickfix = 1
  let g:ale_lint_delay = 1000
  let g:ale_lint_on_text_changed = 'normal'
  let g:ale_lint_on_enter = 1
  let g:ale_lint_on_save = 1
  let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
  " let g:ale_vim_vint_show_style_issues = 0

  " let g:ale_linter_aliases = {
  "       \   'javascript.jsx': 'javascript',
  "       \   'jsx': 'javascript'
  "       \}

  let g:ale_linters = {
        \   'php': [],
        \   'javascript': [],
        \   'typescript': [],
        \   'ruby': ['rubocop'],
        \   'vim': ['vint'],
        \   'eruby': [],
        \}
  " let g:ale_linters = {
  "       \   'rust': [],
  "       \   'go': [],
  "       \   'vue': [],
  "       \   'objcpp': [],
  "       \   'c': [],
  "       \   'java': [],
  "       \   'javascript': [],
  "       \   'dart': [],
  "       \   'tex': [],
  "       \   'wxss': [],
  "       \   'vim': ['vint'],
  "       \   'markdown': [],
  "       \   'python': [],
  "       \   'html': [],
  "       \   'ruby': [],
  "       \   'scss': [],
  "       \   'css': [],
  "       \   'typescript': [],
  "       \   'json': [],
  "       \   'swift': ['swiftlint'],
  "       \}
  let g:ale_fixers = {
        \ 'javascript': ['eslint'],
        \ 'vue': ['eslint'],
        \ 'typescript': ['eslint'],
        \ 'json': ['fixjson'],
        \ 'ruby': ['rubocop']
        \}

  let g:ale_pattern_options = {
        \ '\.min\.js$': {'ale_enabled': 0},
        \ '\.min\.css$': {'ale_enabled': 0},
        \ '\.txt$': {'ale_enabled': 0},
        \ '.*gems/.*\.rb$': {'ale_enabled': 0},
        \ 'Vagrantfile$': {'ale_enabled': 0},
        \}

  let g:ale_sign_error = '✗' " u2717
  let g:ale_sign_warning = '⚠'
  let g:ale_sign_info = 'ℹ'
  let g:ale_sign_style_error = '>>'
  let g:ale_sign_style_warning = '--'

  if get(g:, 'enable_patched_font', 0)
    let g:ale_statusline_format = ['✖ %d', '⚠ %d', '⬥ ok']
  endif

  nmap <silent> <C-k> <Plug>(ale_previous_wrap)
  nmap <silent> <C-j> <Plug>(ale_next_wrap)
  nmap <localleader>j <Plug>(ale_fix)
  nmap <localleader>d <Plug>(ale_detail)
endif
" }}}

