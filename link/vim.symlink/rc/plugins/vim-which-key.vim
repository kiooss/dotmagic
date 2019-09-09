" register dictionary for the <Space>-prefix

call which_key#register('<Space>', "g:space_prefix_dict")

let g:space_prefix_dict =  {}

let g:space_prefix_dict.v = { 'name' : '+denite-vimux' }
let g:space_prefix_dict.r = { 'name' : '+refactor' }
let g:space_prefix_dict.s = { 'name' : '+git' }
let g:space_prefix_dict.m = { 'name' : '+coc-list' }
let g:space_prefix_dict.u = { 'name' : '+util' }

" let g:space_prefix_dict.1 = 'which_key_ignore'
" let g:space_prefix_dict.2 = 'which_key_ignore'
" let g:space_prefix_dict.3 = 'which_key_ignore'
" let g:space_prefix_dict.4 = 'which_key_ignore'
" let g:space_prefix_dict.5 = 'which_key_ignore'
" let g:space_prefix_dict.6 = 'which_key_ignore'
" let g:space_prefix_dict.7 = 'which_key_ignore'
" let g:space_prefix_dict.8 = 'which_key_ignore'
" let g:space_prefix_dict.9 = 'which_key_ignore'

" let g:which_key_use_floating_win = 1
let g:which_key_sep = '➡'
" let g:which_key_vertical = 0
" let g:which_key_position = 'topleft'
let g:which_key_run_map_on_popup = 1
" let g:which_key_default_group_name = '+'

" autocmd! FileType which_key
" autocmd  FileType which_key set laststatus=0 noshowmode noruler
"   \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
