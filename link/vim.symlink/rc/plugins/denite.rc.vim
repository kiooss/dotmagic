"---------------------------------------------------------------------------
" denite.nvim
"

if executable('rg')
  call denite#custom#var('file_rec', 'command',
        \ ['rg', '--files', '--glob', '!.git'])
  " call denite#custom#var('grep', 'command', ['rg', '--threads', '1'])
  " call denite#custom#var('grep', 'recursive_opts', [])
  " call denite#custom#var('grep', 'final_opts', [])
  " call denite#custom#var('grep', 'separator', ['--'])
  " call denite#custom#var('grep', 'default_opts',
  "       \ ['--vimgrep', '--no-heading'])
else
  call denite#custom#var('file_rec', 'command',
        \ ['ag', '--follow', '--nocolor', '--nogroup', '-g', ''])
endif

call denite#custom#source('file_old', 'matchers',
      \ ['matcher_fuzzy', 'matcher_project_files'])
if has('nvim')
  call denite#custom#source('file_rec,grep', 'matchers',
        \ ['matcher_cpsm'])
endif
call denite#custom#source('file_old', 'converters',
      \ ['converter_relative_word'])

" enable devicons
" necessary only if denite is lazy load.
if g:webdevicons_enable_denite
  call denite#custom#source('file_rec,file_old,buffer,directory_rec',
        \ 'converters', ['devicons_denite_converter'])
endif

call denite#custom#alias('source', 'file_rec/git', 'file_rec')
call denite#custom#var('file_rec/git', 'command',
      \ ['git', 'ls-files', '-co', '--exclude-standard'])

call denite#custom#alias('source', 'grep/git', 'grep')
call denite#custom#var('grep/git', 'command',
      \ ['git', 'grep'])
call denite#custom#var('grep/git', 'recursive_opts', [])

" denite option
call denite#custom#option('_', {
      \ 'prompt': '➤',
      \ 'cursor_wrap': v:true,
      \ 'short_source_names': v:true,
      \ 'highlight_matched_char' : 'MoreMsg',
      \ 'highlight_matched_range' : 'MoreMsg',
      \ 'highlight_mode_insert': 'WildMenu'
      \ })

" buffer source
call denite#custom#var(
      \ 'buffer',
      \ 'date_format', '%Y-%m-%d %H:%M:%S')

let s:menus = {}
let s:menus.vim = {
    \ 'description': 'Vim',
    \ }
let s:menus.vim.file_candidates = [
    \ ['    > Edit configuation file (init.vim)', '~/.config/nvim/']
    \ ]
call denite#custom#var('menu', 'menus', s:menus)

" Change ignore_globs
call denite#custom#filter('matcher_ignore_globs', 'ignore_globs',
      \ [ '.git/', '.ropeproject/', '__pycache__/', 'tmp/', 'var/',
      \   'venv/', 'images/', '*.min.*', 'img/', 'fonts/'])

" \  ['<C-N>', '<denite:assign_next_matched_text>', 'noremap'],
" \  ['<C-P>', '<denite:assign_previous_matched_text>', 'noremap'],
" \  ['<Up>', '<denite:assign_previous_text>', 'noremap'],
" \  ['<Down>', '<denite:assign_next_text>', 'noremap'],
" KEY MAPPINGS
let s:insert_mode_mappings = [
      \  ['<C-a>', '<denite:move_caret_to_head>', 'noremap'],
      \  ['<C-e>', '<denite:move_caret_to_tail>', 'noremap'],
      \  ['<C-f>', '<denite:move_caret_to_right>', 'noremap'],
      \  ['<C-b>', '<denite:move_caret_to_left>', 'noremap'],
      \  ['jk', '<denite:enter_mode:normal>', 'noremap'],
      \  ['<C-j>', '<denite:move_to_next_line>', 'noremap'],
      \  ['<C-k>', '<denite:move_to_previous_line>', 'noremap'],
      \  ['<C-v>', '<denite:do_action:vsplit>', 'noremap'],
      \  ['<C-u>', '<denite:delete_entire_text>', 'noremap'],
      \  ['<C-Y>', '<denite:redraw>', 'noremap'],
      \ ]

let s:normal_mode_mappings = [
      \   ["'", '<denite:toggle_select_down>', 'noremap'],
      \   ['<C-n>', '<denite:jump_to_next_source>', 'noremap'],
      \   ['<C-p>', '<denite:jump_to_previous_source>', 'noremap'],
      \   ['gg', '<denite:move_to_first_line>', 'noremap'],
      \   ['st', '<denite:do_action:tabopen>', 'noremap'],
      \   ['sp', '<denite:do_action:vsplit>', 'noremap'],
      \   ['sh', '<denite:do_action:split>', 'noremap'],
      \   ['q', '<denite:quit>', 'noremap'],
      \   ['r', '<denite:redraw>', 'noremap'],
      \ ]

for s:m in s:insert_mode_mappings
  call denite#custom#map('insert', s:m[0], s:m[1], s:m[2])
endfor
for s:m in s:normal_mode_mappings
  call denite#custom#map('normal', s:m[0], s:m[1], s:m[2])
endfor

unlet s:m s:insert_mode_mappings s:normal_mode_mappings

