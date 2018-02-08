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
