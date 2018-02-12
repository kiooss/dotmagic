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

