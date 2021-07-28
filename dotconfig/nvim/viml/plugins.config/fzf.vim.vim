scriptencoding utf-8

if has('nvim') || has('gui_running')
  let $FZF_DEFAULT_OPTS .= ' --inline-info'
endif

" Fzf previx
" let g:fzf_command_prefix = 'Fzf'

let g:fzf_files_options='--preview-window down:wrap --reverse'
let g:fzf_layout = { 'window': 'call UserFzfOpenWin()' }

function! UserFzfOpenWin()
    let width = min([&columns - 4, max([80, &columns - 20])])
    let height = min([&lines - 4, max([20, &lines - 10])])
    let top = ((&lines - height) / 2) - 1
    let left = (&columns - width) / 2
    let opts = {'relative': 'editor', 'row': top, 'col': left, 'width': width, 'height': height, 'style': 'minimal'}

    let top = "╭" . repeat("─", width - 2) . "╮"
    let mid = "│" . repeat(" ", width - 2) . "│"
    let bot = "╰" . repeat("─", width - 2) . "╯"
    let lines = [top] + repeat([mid], height - 2) + [bot]
    let s:buf_bg = nvim_create_buf(v:false, v:true)
    call nvim_buf_set_lines(s:buf_bg, 0, -1, v:true, lines)
    let s:bwin = nvim_open_win(s:buf_bg, v:true, opts)
    set winhl=Normal:Comment
    let opts.row += 1
    let opts.height -= 2
    let opts.col += 2
    let opts.width -= 4
    call nvim_open_win(nvim_create_buf(v:false, v:true), v:true, opts)

    setlocal
          \ buftype=nofile
          \ nobuflisted
          \ bufhidden=hide
          \ nonumber
          \ norelativenumber
          \ signcolumn=no

    autocmd WinLeave * ++once call nvim_win_close(s:bwin, v:false)
      \| execute 'bwipeout ' . s:buf_bg
endfunction

" command! -bang -nargs=? -complete=dir FzfFiles
"   \ call fzf#vim#files(<q-args>, fzf#vim#with_preview('down:50%', '?'), <bang>0)

" command! -bang -nargs=? -complete=dir FzfFiles
"   \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

" command! -bang -nargs=? -complete=dir FzfGFiles
"   \ call fzf#vim#gitfiles(<q-args>, fzf#vim#with_preview(), <bang>0)

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
