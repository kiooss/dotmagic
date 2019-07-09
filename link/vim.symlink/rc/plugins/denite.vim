"---------------------------------------------------------------------------
" denite.nvim
"
let g:webdevicons_enable_denite = 1

" INTERFACE
call denite#custom#option('_', {
      \ 'prompt': 'λ>',
      \ 'vertical-preview': v:true,
      \ 'auto-resume': 1,
      \ 'statusline': v:false,
      \ 'split': 'floating',
      \ 'highlight-matched-char' : 'MoreMsg',
      \ 'highlight-matched-range' : 'MoreMsg',
      \ })

" MATCHERS
" Default is 'matcher_fuzzy'
call denite#custom#source('file/old', 'matchers',
      \ ['matcher/fuzzy', 'matcher/project_files', 'matcher/ignore_globs'])
call denite#custom#source('tag', 'matchers', ['matcher/substring'])

if has('nvim') && &runtimepath =~# '\/cpsm'
  call denite#custom#source(
        \ 'buffer,file/rec,grep,file/rec/git,grep/git',
        \ 'matchers', ['matcher_cpsm', 'matcher_fuzzy', 'matcher/ignore_globs'])
endif

" CONVERTERS
" Default is none
if get(g:, 'webdevicons_enable_denite', 0)
  call denite#custom#source(
        \ 'file/rec,file/rec/git,file/old,buffer,directory_rec',
        \ 'converters', ['devicons_denite_converter', 'converter_relative_word'])
else
  call denite#custom#source(
        \ 'file/rec,file/old,buffer,file_mru,directory_rec',
        \ 'converters', ['converter_relative_word'])
endif

" Change file_rec command.
" if executable('rg')
"   call denite#custom#var('file/rec', 'command',
"         \ ['rg', '--color', 'never', '--files'])
" endif

" FIND and GREP COMMANDS
if executable('ag')
  " The Silver Searcher
  call denite#custom#var('file/rec', 'command',
        \ ['ag', '-U', '--hidden', '--follow', '--nocolor', '--nogroup', '-g', ''])

  " Setup ignore patterns in your .agignore file!
  " https://github.com/ggreer/the_silver_searcher/wiki/Advanced-Usage

  call denite#custom#var('grep', 'command', ['ag'])
  call denite#custom#var('grep', 'recursive_opts', [])
  call denite#custom#var('grep', 'pattern_opt', [])
  call denite#custom#var('grep', 'separator', ['--'])
  call denite#custom#var('grep', 'final_opts', [])
  call denite#custom#var('grep', 'default_opts',
        \ [ '--skip-vcs-ignores', '--vimgrep', '--smart-case', '--hidden' ])

elseif executable('ack')
  " Ack command
  call denite#custom#var('grep', 'command', ['ack'])
  call denite#custom#var('grep', 'recursive_opts', [])
  call denite#custom#var('grep', 'pattern_opt', ['--match'])
  call denite#custom#var('grep', 'separator', ['--'])
  call denite#custom#var('grep', 'final_opts', [])
  call denite#custom#var('grep', 'default_opts',
        \ ['--ackrc', $HOME.'/.config/ackrc', '-H',
        \ '--nopager', '--nocolor', '--nogroup', '--column'])
endif


call denite#custom#alias('source', 'file/rec/git', 'file/rec')
call denite#custom#var('file/rec/git', 'command',
      \ ['git', 'ls-files', '-co', '--exclude-standard'])

call denite#custom#alias('source', 'grep/git', 'grep')
call denite#custom#var('grep/git', 'command',
      \ ['git', 'grep'])
call denite#custom#var('grep/git', 'recursive_opts', [])

" buffer source
call denite#custom#var(
      \ 'buffer',
      \ 'date_format', '%Y-%m-%d %H:%M:%S')

" Change ignore_globs
call denite#custom#filter('matcher/ignore_globs', 'ignore_globs',
      \ [ '.git/', '.ropeproject/', '__pycache__/', 'tmp/', 'var/', '.deprecated/',
      \   'venv/', 'images/', '*.min.*', 'img/', 'fonts/', 'tags', '*.png', '*.bmp'])

" \  ['<C-N>', '<denite:assign_next_matched_text>', 'noremap'],
" \  ['<C-P>', '<denite:assign_previous_matched_text>', 'noremap'],
" \  ['<Up>', '<denite:assign_previous_text>', 'noremap'],
" \  ['<Down>', '<denite:assign_next_text>', 'noremap'],
" KEY MAPPINGS
" let s:insert_mode_mappings = [
"       \  ['<C-a>', '<denite:move_caret_to_head>', 'noremap'],
"       \  ['<C-e>', '<denite:move_caret_to_tail>', 'noremap'],
"       \  ['<C-f>', '<denite:move_caret_to_right>', 'noremap'],
"       \  ['<C-b>', '<denite:move_caret_to_left>', 'noremap'],
"       \  ['jk', '<denite:enter_mode:normal>', 'noremap'],
"       \  ['<C-j>', '<denite:move_to_next_line>', 'noremap'],
"       \  ['<C-k>', '<denite:move_to_previous_line>', 'noremap'],
"       \  ['<C-v>', '<denite:do_action:vsplit>', 'noremap'],
"       \  ['<C-u>', '<denite:delete_entire_text>', 'noremap'],
"       \  ['<C-Y>', '<denite:redraw>', 'noremap'],
"       \  ['<C-r>', '<denite:toggle_matchers:matcher/substring>', 'noremap'],
"       \ ]

" let s:normal_mode_mappings = [
"       \   ["'", '<denite:toggle_select_down>', 'noremap'],
"       \   ['<C-n>', '<denite:jump_to_next_source>', 'noremap'],
"       \   ['<C-p>', '<denite:jump_to_previous_source>', 'noremap'],
"       \   ['gg', '<denite:move_to_first_line>', 'noremap'],
"       \   ['st', '<denite:do_action:tabopen>', 'noremap'],
"       \   ['sp', '<denite:do_action:vsplit>', 'noremap'],
"       \   ['sh', '<denite:do_action:split>', 'noremap'],
"       \   ['q', '<denite:quit>', 'noremap'],
"       \   ['r', '<denite:redraw>', 'noremap'],

" for s:m in s:insert_mode_mappings
"   call denite#custom#map('insert', s:m[0], s:m[1], s:m[2])
" endfor
" for s:m in s:normal_mode_mappings
"   call denite#custom#map('normal', s:m[0], s:m[1], s:m[2])
" endfor

" unlet s:m s:insert_mode_mappings s:normal_mode_mappings

" Define mappings
autocmd FileType denite call s:denite_my_settings()
function! s:denite_my_settings() abort
  nnoremap <silent><buffer><expr> <CR>
  \ denite#do_map('do_action')
  nnoremap <silent><buffer><expr> d
  \ denite#do_map('do_action', 'delete')
  nnoremap <silent><buffer><expr> p
  \ denite#do_map('do_action', 'preview')
  nnoremap <silent><buffer><expr> q
  \ denite#do_map('quit')
  nnoremap <silent><buffer><expr> v
  \ denite#do_map('do_action', 'vsplit')
  nnoremap <silent><buffer><expr> i
  \ denite#do_map('open_filter_buffer')
  nnoremap <silent><buffer><expr> s
  \ denite#do_map('toggle_select').'j'
endfunction

autocmd FileType denite-filter call s:denite_filter_my_settings()
function! s:denite_filter_my_settings() abort
  imap <silent><buffer> <esc> <Plug>(denite_filter_quit)
  imap <silent><buffer> jk <Plug>(denite_filter_quit)
  imap <silent><buffer> <C-c> <Plug>(denite_filter_quit)q
endfunction

nnoremap <silent> <Leader><Leader> :<C-u>Denite buffer file/old -default-action=switch<CR>
nnoremap <silent> <LocalLeader>o :<C-u>Denite outline -start-filter<CR>
nnoremap <silent> <LocalLeader>vv :<C-u>Denite file/rec/git:~/.dotfiles/link/vim.symlink/ -start-filter<CR>
nnoremap <silent> <LocalLeader>vd :<C-u>Denite dein -default-action=open<CR>
nnoremap <silent> <LocalLeader>vc :<C-u>Denite colorscheme -auto-preview -start-filter<CR>
nnoremap <silent> <LocalLeader>vf :<C-u>Denite filetype -start-filter<CR>
nnoremap <silent> <LocalLeader>vh :<C-u>Denite -buffer-name=search-help -start-filter help<CR>

nnoremap <silent> <LocalLeader>r
      \ :<C-u>Denite -buffer-name=register register<CR>
xnoremap <silent> <LocalLeader>r
      \ :<C-u>Denite -mode=normal -default-action=replace -buffer-name=register register<CR>

nnoremap <silent><expr> / line('$') > 10000 ? '/' :
\ ":\<C-u>Denite -buffer-name=search%`bufnr('%')` -start-filter line\<CR>"
nnoremap <silent><expr> n line('$') > 10000 ? 'n' :
\ ":\<C-u>Denite -buffer-name=search%`bufnr('%')` -resume -refresh -no-start-filter\<CR>"
nnoremap <silent><expr> * line('$') > 10000 ? '*' :
\ ":\<C-u>DeniteCursorWord -buffer-name=search line\<CR>"

nnoremap <silent> <LocalLeader>g :<C-u>Denite -buffer-name=search -no-empty grep/git<CR>
nnoremap <silent> # :<C-u>DeniteCursorWord -buffer-name=search -no-empty grep/git<CR>
nnoremap <silent><expr> tp  &filetype == 'help' ?
      \ ":\<C-u>pop\<CR>" : ":\<C-u>Denite -mode=normal jump\<CR>"
