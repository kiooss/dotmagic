setlocal matchpairs-=<:>     " Annoying when not closing <?php tag
setlocal makeprg=php\ -l\ %  " Use php syntax check when doing :make
setlocal errorformat=%m\ in\ %f\ on\ line\ %l
setlocal iskeyword+=\\       " Add the namespace separator as a keyword
" setlocal path+=/usr/local/share/pear

" setlocal nocursorline
" setlocal norelativenumber
"
" syntax sync minlines=100
" syntax sync maxlines=240
" set synmaxcol=800


let php_html_load=0
let php_html_in_heredoc=0
let php_html_in_nowdoc=0

let php_sql_query=0
let php_sql_heredoc=0
let php_sql_nowdoc=0
