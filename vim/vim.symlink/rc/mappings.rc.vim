"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Mapping settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"{{{

" Swap ; and :
" noremap ; :
" noremap : ;

" enter in normal mode do nothing
nnoremap <CR> <NOP>

" remap esc
inoremap jk <esc>
inoremap <C-e> <C-o>A

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

" clear highlighted search
noremap <F3> :set hlsearch! hlsearch?<cr>

" Window moving
nnoremap <Up> <C-W>j<C-W>_
nnoremap <Down> <C-W>k<C-W>_
nnoremap <Left> <C-W>h<C-W>_
nnoremap <Right> <C-W>l<C-W>_

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
nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>

" move to beginning/end of line
nnoremap B ^
nnoremap E $

" map for command mode
" cnoremap <C-j> <t_kd>
" cnoremap <C-k> <t_ku>
cnoremap <C-a> <Home>
cnoremap <C-e> <End>

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
" Ctrl-a: Go to begin of line
inoremap <c-a> <esc>I

" Ctrl-e: Go to end of line
inoremap <c-e> <esc>A

" Ctrl-f: Move cursor left
inoremap <c-f> <Left>

" Ctrl-u: Delete til beginning of line, create undo point
inoremap <c-u> <c-g>u<c-u>




"}}}
