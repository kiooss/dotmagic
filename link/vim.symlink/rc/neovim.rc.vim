"=============================================================================
" neovim.rc.vim--- Config for neovim
" => Yang Yang
"=============================================================================

" Search and use environments specifically made for Neovim.
if isdirectory($VARPATH.'/venv/neovim2')
  let g:python_host_prog = $VARPATH.'/venv/neovim2/bin/python'
endif
if isdirectory($VARPATH.'/venv/neovim3')
  let g:python3_host_prog = $VARPATH.'/venv/neovim3/bin/python'
endif
let g:ruby_host_prog = '~/.rbenv/versions/2.2.4/bin/neovim-ruby-host'

let g:cursor_shape = 2

if g:cursor_shape == 0
  " prevent nvim from changing the cursor shape
  set guicursor=
elseif g:cursor_shape == 1
  " enable non-blinking mode-sensitive cursor
  set guicursor=n-v-c:block-blinkon0,i-ci-ve:ver25-blinkon0,r-cr:hor20,o:hor50
elseif g:cursor_shape == 2
  " enable blinking mode-sensitive cursor
  set guicursor=n-v-c:block-blinkon10,i-ci-ve:ver25-blinkon10,r-cr:hor20,o:hor50
endif

if exists('&inccommand')
  set inccommand=nosplit
endif

" Share the histories
autocmd MyAutoCmd CursorHold *
      \if exists(':rshada') | rshada | wshada | endif

autocmd MyAutoCmd FocusGained * checktime

" Set terminal colors
let s:num = 0
for s:color in [
      \ '#6c6c6c', '#ff6666', '#66ff66', '#ffd30a',
      \ '#1e95fd', '#ff13ff', '#1bc8c8', '#c0c0c0',
      \ '#383838', '#ff4444', '#44ff44', '#ffb30a',
      \ '#6699ff', '#f820ff', '#4ae2e2', '#ffffff',
      \ ]
  let g:terminal_color_{s:num} = s:color
  let s:num += 1
endfor
unlet! s:num
unlet! s:color

" Modifiable terminal
autocmd MyAutoCmd TermOpen * setlocal modifiable
autocmd MyAutoCmd TermClose * buffer #

let g:terminal_scrollback_buffer_size = 3000

command! -complete=file -nargs=* Nrun :call s:Terminal(<q-args>)

function! s:Terminal(cmd)
  execute 'belowright 5new'
  set winfixheight
  call termopen(a:cmd, {
        \ 'on_exit': function('s:OnExit'),
        \ 'buffer_nr': bufnr('%'),
        \})
  call setbufvar('%', 'is_autorun', 1)
  execute 'wincmd p'
endfunction

function! s:OnExit(job_id, status, event) dict
  if a:status == 0
    execute 'silent! bd! '.self.buffer_nr
  endif
endfunction
