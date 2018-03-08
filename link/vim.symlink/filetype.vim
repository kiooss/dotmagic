" ------------------------------------------------
" File-type Detection
" ------------------------------------------------

if exists('did_load_filetypes')
  finish
endif

augroup filetypedetect

  autocmd BufNewFile,BufRead .tern-project setfiletype json
  autocmd BufNewFile,BufRead .jsbeautifyrc setfiletype json
  autocmd BufNewFile,BufRead .eslintrc     setfiletype json
  autocmd BufNewFile,BufRead .jscsrc       setfiletype json

  autocmd BufRead,BufNewFile *.js setfiletype javascript.jsx
  autocmd BufRead,BufNewFile *_js.html.erb setfiletype javascript
  autocmd BufRead,BufNewFile *_js.html.twig setfiletype javascript
  autocmd BufRead,BufNewFile *.xlsx.axlsx setfiletype ruby
  autocmd BufRead,BufNewFile *.ihtml setfiletype php
  autocmd BufRead,BufNewFile *.ejs setfiletype html
  autocmd BufRead,BufNewFile *.ino setfiletype c
  autocmd BufRead,BufNewFile *.svg setfiletype xml
  autocmd BufRead,BufNewFile *.tmuxtheme setfiletype tmux
  autocmd BufNewFile,BufReadPost *.md setfiletype markdown

augroup END
