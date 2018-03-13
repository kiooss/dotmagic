"---------------------------------------------------------------------------
" deoplete.nvim
"
let g:deoplete#enable_at_startup = 1
let g:deoplete#buffer#require_same_filetype = 0
let g:deoplete#enable_refresh_always = 0
let g:deoplete#enable_camel_case = 1
let g:deoplete#skip_chars = ['(', ')']
" use phpcd
let g:deoplete#ignore_sources = get(g:, 'deoplete#ignore_sources', {})
let g:deoplete#ignore_sources.php = ['omni']

let g:deoplete#keyword_patterns = get(g:, 'deoplete#keyword_patterns', {})
let g:deoplete#keyword_patterns._ = '[a-zA-Z_]\k*\(?'
let g:deoplete#keyword_patterns.tex = '[^\w|\s][a-zA-Z_]\w*'
" Omni input_patterns and functions {{{
let g:deoplete#omni#input_patterns = get(g:, 'deoplete#omni#input_patterns', {})
let g:deoplete#omni#input_patterns.python = ''
let g:deoplete#omni#input_patterns.ruby = ['[^. *\t]\.\w*', '[a-zA-Z_]\w*::']
let g:deoplete#omni#input_patterns.xml = '<[^>]*'
let g:deoplete#omni#input_patterns.md = '<[^>]*'
let g:deoplete#omni#input_patterns.css  = '^\s\+\w\+\|\w\+[):;]\?\s\+\w*\|[@!]'
let g:deoplete#omni#input_patterns.scss = '^\s\+\w\+\|\w\+[):;]\?\s\+\w*\|[@!]'
let g:deoplete#omni#input_patterns.sass = '^\s\+\w\+\|\w\+[):;]\?\s\+\w*\|[@!]'
let g:deoplete#omni#input_patterns.javascript = ''

let g:deoplete#omni#functions = get(g:, 'deoplete#omni#functions', {})
let g:deoplete#omni#functions.ruby = 'rubycomplete#Complete'
let g:deoplete#omni#functions.css = 'csscomplete#CompleteCSS'
let g:deoplete#omni#functions.html = 'htmlcomplete#CompleteTags'
let g:deoplete#omni#functions.markdown = 'htmlcomplete#CompleteTags'
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
" call deoplete#custom#source('buffer', 'mark', '')
" call deoplete#custom#source('_', 'disabled_syntaxes', ['Comment', 'String'])
" call deoplete#custom#source('buffer', 'mark', '*')

" Change the source rank
call deoplete#custom#source('ultisnips', 'rank', 210)
call deoplete#custom#source('phpcd', 'rank', 200)
call deoplete#custom#source('buffer', 'rank', 110)

call deoplete#custom#source('omni',       'mark',  '⌾')
call deoplete#custom#source('buffer',     'mark',  'ℬ')
call deoplete#custom#source('tag',        'mark',  '⌦')
call deoplete#custom#source('around',     'mark',  '↻')
call deoplete#custom#source('vim',        'mark',  '')
call deoplete#custom#source('phpcd',      'mark',  '')
call deoplete#custom#source('look',       'mark',  'ℒ𝒪𝒪𝒦')
call deoplete#custom#source('ultisnips',  'mark',  '⌘')

" converters
call deoplete#custom#source('_', 'converters', [
      \ 'converter_remove_paren',
      \ 'converter_remove_overlap',
      \ 'converter_truncate_abbr',
      \ 'converter_truncate_menu',
      \ 'converter_auto_delimiter',
      \ ])

" call deoplete#custom#source('buffer', 'min_pattern_length', 9999)
" call deoplete#custom#source('clang', 'input_pattern', '\.\w*|\.->\w*|\w+::\w*')
" call deoplete#custom#source('clang', 'max_pattern_length', -1)

call deoplete#custom#source('look', 'min_pattern_length', 4)
"}}}
" Debug config {{{
" let g:deoplete#enable_profile = 1
" call deoplete#enable_logging('DEBUG', 'deoplete.log')
" call deoplete#custom#source('clang', 'debug_enabled', 1)
"}}}
" vim: set ts=2 sw=2 tw=80 et fdm=marker fdl=0:
