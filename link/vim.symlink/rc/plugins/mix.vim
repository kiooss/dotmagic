"==============================================================================
" mix.vim---Mixed plugin settings.
" => Yang Yang
"==============================================================================

function! s:has_plug(name) abort
  if exists("*dein#tap")
    return dein#tap(a:name)
  else
    return 0
  endif
endfunction

" FZF {{{
if s:has_plug('fzf.vim')
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
  nnoremap <silent> <LocalLeader>f :GFiles --exclude-standard --cached --others<CR>
  nnoremap <silent> <LocalLeader>F :Files<CR>
  nnoremap <silent> <LocalLeader>; :Lines<CR>
  nnoremap <silent> <LocalLeader>g :GrepWord<CR>
  xnoremap <silent> <LocalLeader>g y:GrepWord <C-R>"<CR>
  nnoremap <silent> <LocalLeader>ag :Ag <C-R><C-W><CR>
  nnoremap <silent> <LocalLeader>AG :Ag <C-R><C-A><CR>

  inoremap <expr> <c-x><c-t> fzf#complete('tmuxwords.rb --all-but-current --scroll 500 --min 5')

endif
"}}}
