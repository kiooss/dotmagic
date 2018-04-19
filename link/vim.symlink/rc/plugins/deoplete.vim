"---------------------------------------------------------------------------
" deoplete.nvim
"
let g:deoplete#enable_at_startup = 1
" custom options {{{
call deoplete#custom#option('camel_case', v:true)
call deoplete#custom#option('ship_chars', ['(', ')', '<', '>'])
" ignore sources
call deoplete#custom#option('ignore_sources', {
      \ '_': ['tag'],
      \ 'php': ['omni']
      \})
" keywordk patterns
call deoplete#custom#option('keyword_patterns', {
      \ '_': '[a-zA-Z_]\k*\(?',
      \ 'tex': '[^\w|\s][a-zA-Z_]\w*',
      \ })
"}}}
" Key-mappings and Events " {{{
" ---
" <TAB>: completion.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ deoplete#manual_complete()
function! s:check_back_space() abort "{{{
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction "}}}

" <S-TAB>: completion back.
inoremap <expr><S-TAB>  pumvisible() ? "\<C-p>" : "\<C-h>"

" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> deoplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> deoplete#smart_close_popup()."\<C-h>"

" inoremap <expr><C-g> deoplete#undo_completion()

" Redraw candidates
inoremap <expr><C-g> deoplete#refresh()
inoremap <expr><C-l> deoplete#complete_common_string()

" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function() abort "{{{
  return deoplete#close_popup() . "\<CR>"
endfunction "}}}

" inoremap <expr> '  pumvisible() ? deoplete#close_popup() : "'"

" conflict with UltiSnips mapping.
" inoremap <expr><C-j> pumvisible() ? "\<C-n>" : "\<C-j>"
" inoremap <expr><C-k> pumvisible() ? "\<C-p>" : "\<C-k>"
" }}}
" Source config {{{
" call deoplete#custom#source('_', 'matchers', ['matcher_head'])
" call deoplete#custom#source('_', 'matchers', ['matcher_full_fuzzy'])
" call deoplete#custom#source('ghc', 'sorters', ['sorter_word'])
" call deoplete#custom#source('_', 'disabled_syntaxes', ['Comment', 'String'])

" Default matchers and sorters
" call deoplete#custom#source('_', 'matchers', ['matcher_fuzzy'])
" call deoplete#custom#source('_', 'sorters', ['sorter_rank'])


" matcher_length removes candidates shorter than or equal to the user input.
call deoplete#custom#source('_', 'matchers', ['matcher_fuzzy', 'matcher_length'])
call deoplete#custom#source('ultisnips', 'matchers', ['matcher_fuzzy'])

" converters
call deoplete#custom#source('_', 'converters', [
      \ 'converter_remove_paren',
      \ 'converter_remove_overlap',
      \ 'converter_truncate_abbr',
      \ 'converter_truncate_menu',
      \ 'converter_auto_delimiter',
      \ ])

" Change the source rank
call deoplete#custom#source('ultisnips',   'rank',  1000)
call deoplete#custom#source('phpcd',       'rank',  500)
call deoplete#custom#source('omni',        'rank',  420)
call deoplete#custom#source('file',        'rank',  410)
call deoplete#custom#source('around',      'rank',  330)
call deoplete#custom#source('buffer',      'rank',  320)
call deoplete#custom#source('dictionary',  'rank',  310)
call deoplete#custom#source('look',        'rank',  100)

call deoplete#custom#source('omni',       'mark',  '⌾')
call deoplete#custom#source('buffer',     'mark',  'ℬ')
call deoplete#custom#source('tag',        'mark',  '⌦')
call deoplete#custom#source('around',     'mark',  '↻')
call deoplete#custom#source('vim',        'mark',  '')
call deoplete#custom#source('phpcd',      'mark',  '')
call deoplete#custom#source('look',       'mark',  'ℒ𝒪𝒪𝒦')
call deoplete#custom#source('ultisnips',  'mark',  '⌘')

call deoplete#custom#source('buffer', 'require_same_filetype', v:false)
call deoplete#custom#source('look', 'min_pattern_length', 4)
call deoplete#custom#source('file', 'enable_buffer_path', v:true)

" Omni input_patterns and functions
call deoplete#custom#source('omni', 'input_patterns', {
      \'xml': '<[^>]*',
      \'md': '<[^>]*',
      \'css': '^\s\+\w\+\|\w\+[):;]\?\s\+\w*\|[@!]',
      \'scss': '^\s\+\w\+\|\w\+[):;]\?\s\+\w*\|[@!]',
      \'sass': '^\s\+\w\+\|\w\+[):;]\?\s\+\w*\|[@!]',
      \})

call deoplete#custom#source('omni', 'functions', {
      \'css': 'csscomplete#CompleteCSS',
      \'html': 'htmlcomplete#CompleteTags',
      \'markdown': 'htmlcomplete#CompleteTags',
      \})

"}}}
" Debug config {{{
" let g:deoplete#enable_profile = 1
" call deoplete#enable_logging('DEBUG', 'deoplete.log')
" call deoplete#custom#source('clang', 'debug_enabled', 1)
"}}}
" vim: set ts=2 sw=2 tw=80 et fdm=marker fdl=0:
