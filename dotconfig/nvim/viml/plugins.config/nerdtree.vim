" close NERDTree after a file is opened
let NERDTreeQuitOnOpen=0
" show hidden files in NERDTree
let NERDTreeShowHidden=1
" remove some files by extension
let NERDTreeIgnore = ['\.js.map$', '\~$', '\.o$[[file]]', '\.git$']
" Toggle NERDTree
nnoremap <silent> <Leader>nt :NERDTreeToggle<CR>
nnoremap <silent> <Leader>nf :NERDTreeFind<CR>
" expand to the path of the file in the current buffer
" nnoremap <expr><silent> <leader>nf g:NERDTree.IsOpen() ?
"       \ ":NERDTreeClose<CR>" : ":NERDTreeFind<CR>"
" open NERDTree automatically when vim starts up on opening a directory
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) &&
      \ !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
" close vim if the only window left open is a NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") &&
      \ b:NERDTree.isTabTree()) | q | endif
