"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Mapping settings
" vim: foldmethod=marker
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"{{{
" Swap ; and :
" noremap ; :
" noremap : ;

" enter in normal mode do nothing
nnoremap <CR> <NOP>

nnoremap <Leader>w :w<cr>
nnoremap <Leader>q :q<cr>
nnoremap <silent> <Leader>b :bd<cr>
nnoremap <Leader>0 :qa!<cr>
nnoremap <Leader>r :e!<cr>
nnoremap <Leader>x :x<cr>
nnoremap <Leader><Tab> <C-^>
nnoremap <Leader>p :pu<CR>
nnoremap <Leader>t :TagbarToggle<CR>
nnoremap <Leader>l :set list!<CR>

nnoremap j gj
nnoremap k gk

nnoremap g; g;zz
nnoremap g, g,zz

" clear highlighted search
noremap <F3> :set hlsearch! hlsearch?<cr>

" Window moving
nnoremap <Up> <C-W>j<C-W>_
nnoremap <Down> <C-W>k<C-W>_
nnoremap <Left> <C-W>h<C-W>_
nnoremap <Right> <C-W>l<C-W>_

" Redraw.
nnoremap <silent> <C-l>    :<C-u>redraw!<CR>

" simplify resizing splits
if has('unix')
    nnoremap j <C-w>-
    nnoremap k <C-w>+
    nnoremap h <C-w><
    nnoremap l <C-w>>
else
    nnoremap <M-j> <C-w>-
    nnoremap <M-k> <C-w>+
    nnoremap <M-h> <C-w><
    nnoremap <M-l> <C-w>>
endif

" scroll the viewport faster
nnoremap <C-e> 3<C-e>M
nnoremap <C-y> 3<C-y>M

" move to beginning/end of line
nnoremap B ^
nnoremap E $

" stile select when indent in visual mode
vnoremap < <gv
vnoremap > >gv

" Open the definition in a vertical split
map <A-]> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>

inoremap {%     {%  %}<Left><Left><Left>
inoremap <%     <%  %><Left><Left><Left>

"===============================================================================
" Normal Mode Key Mappings
"===============================================================================
" q: record macros
" w: Move word forward
" e: Move to end of word
" r: Replace single character
" t: Find till
" y: Yank. Last yank is always stored in register 0. So paste with "0p if you did a delete after the yank
" u: Undo
" i: Insert before cursor
" o: Insert line below cursor
" p: Paste
nnoremap p gp

"===============================================================================
" Normal Mode Shift Key Mappings
"===============================================================================
" +/-: Increment number
nnoremap + <c-a>
nnoremap - <c-x>

"===============================================================================
" Insert Mode Ctrl Key Mappings
"===============================================================================
" remap esc
inoremap jk <esc>
inoremap jj <esc>

" <C-b>: previous char.
inoremap <C-b>          <Left>
" <C-f>: next char.
inoremap <C-f>          <Right>

" Ctrl-a: Go to begin of line
inoremap <C-a> <C-o>I

" Ctrl-e: Go to end of line
inoremap <C-e> <C-o>A

" Ctrl-u: Delete til beginning of line, create undo point
inoremap <C-u> <C-g>u<C-u>
" }}}

"===============================================================================
" Command Mode Key Mappings
"===============================================================================
" Command-line mode keymappings:"{{{
" <C-a>, A: move to head.
cnoremap <C-a>          <Home>
" <C-b>: previous char.
cnoremap <C-b>          <Left>
" <C-f>: next char.
cnoremap <C-f>          <Right>
" <C-d>: delete char.
cnoremap <C-d>          <Del>
" <C-e>, E: move to end.
cnoremap <C-e>          <End>
" <C-y>: paste.
cnoremap <C-y>          <C-r>*
" <C-g>: Exit.
cnoremap <C-g>          <C-c>
"}}}
