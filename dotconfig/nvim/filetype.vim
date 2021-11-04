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
  autocmd BufNewFile,BufRead *.env.*       setfiletype sh

  autocmd BufNewFile,BufRead *.cjsx setfiletype javascript.jsx
  autocmd BufNewFile,BufRead *.ejs setfiletype html
  autocmd BufNewFile,BufRead *.ihtml setfiletype php
  autocmd BufNewFile,BufRead *.ino setfiletype c
  " autocmd BufNewFile,BufRead *.js setfiletype javascript.jsx
  autocmd BufNewFile,BufRead *.json setfiletype jsonc
  autocmd BufNewFile,BufRead *.svg setfiletype xml
  autocmd BufNewFile,BufRead *.tmuxtheme setfiletype tmux
  autocmd BufNewFile,BufRead *.wsdl setfiletype xml
  autocmd BufNewFile,BufRead *.xlsx.axlsx setfiletype ruby
  autocmd BufNewFile,BufRead *_js.html.erb setfiletype javascript
  autocmd BufNewFile,BufRead *_js.html.twig setfiletype javascript

augroup END
