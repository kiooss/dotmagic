"==============================================================================
" => Mapping settings
" vim: foldmethod=marker
"==============================================================================

"==============================================================================
" Normal Mode Key Mappings
"==============================================================================
" {{{
" defauts
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

" Swap ; and :
" noremap ; :
" noremap : ;

" Smart space mapping
nmap  <Space>   [Space]
nnoremap  [Space]   <Nop>

" enter in normal mode do nothing
nnoremap <CR> <NOP>

nnoremap <silent> <Leader>w :update<cr>
nnoremap <silent> <Leader>hc :pc<cr>
nnoremap <silent> <Leader>q :q<cr>
nnoremap <silent> <Leader>z :qa!<cr>
nnoremap <silent> <Leader>b :bd<cr>
nnoremap <Leader>x :x<cr>
nnoremap <Leader><Tab> <C-^>
nnoremap <Leader>p :pu<CR>
nnoremap <Leader>t :TagbarToggle<CR>
nnoremap <Leader>l :set list!<CR>
nnoremap <silent> <Leader>y :call system('nc localhost 8377', @")<CR>

nnoremap j gj
nnoremap k gk

nnoremap g; g;zz
nnoremap g, g,zz

nnoremap > >>
nnoremap < <<

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

" <tab> / <s-tab> | Circular windows navigation
nnoremap <tab>   <c-w>w
nnoremap <S-tab> <c-w>W

" scroll the viewport faster
nnoremap <C-e> 3<C-e>M
nnoremap <C-y> 3<C-y>M

" move to beginning/end of line
nnoremap B ^
nnoremap E $

" Open the definition in a vertical split
map <A-]> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>

" Tags
nnoremap g] g<C-]>
nnoremap g[ :pop<cr>

nnoremap p gp

" disable EX mode, use Q to playback q record.
nnoremap Q @q

" Toggle folds
nnoremap <silent> <leader><Space> @=(foldlevel('.')?'za':"\<Space>")<CR>

" +/-: Increment number
nnoremap + <c-a>
nnoremap - <c-x>

"}}}

"==============================================================================
" Insert Mode Ctrl Key Mappings
"==============================================================================
" {{{
" remap esc
inoremap jk <esc>

" <C-b>: previous char.
inoremap <C-b> <Left>
" <C-f>: next char.
inoremap <C-f> <Right>

" Ctrl-a: Go to begin of line
inoremap <C-a> <C-o>I

" Ctrl-e: Go to end of line
inoremap <C-e> <C-o>A

" Ctrl-u: Delete til beginning of line, create undo point
inoremap <C-u> <C-g>u<C-u>

inoremap <C-t> <></><Esc>5hdiwp3lpT>i

inoremap {%     {%  %}<Left><Left><Left>
inoremap <%     <%  %><Left><Left><Left>
" }}}

"==============================================================================
" Command Mode Key Mappings
"==============================================================================
" {{{
" jk | Escaping!
cnoremap jk             <C-c>
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
" <C-v>: paste.
cnoremap <C-v>          <C-r>*
" <C-g>: Exit.
cnoremap <C-g>          <C-c>
" <C-k>: delete to end.
cnoremap <C-k>          <C-\>estrpart(getcmdline(),0,getcmdpos()-1)<CR>
"}}}

"=============================================================================
" Visual Mode Key Mappings
"=============================================================================
" {{{
if (!has('nvim') || $DISPLAY != '') && has('clipboard')
  xnoremap <silent> y "*y:let [@+,@"]=[@*,@*]<CR>
endif

" use J,K to move sleceted lines.
xmap J ]egv=gv
xmap K [egv=gv

" stile select when indent in visual mode
vnoremap < <gv
vnoremap > >gv

" vnoremap <Leader><Space> zf
"}}}

"==============================================================================
" Overview of which map command works in which mode.
"==============================================================================
"{{{
"      COMMANDS                    MODES ~
" :map   :noremap  :unmap     Normal, Visual, Select, Operator-pending
" :nmap  :nnoremap :nunmap    Normal
" :vmap  :vnoremap :vunmap    Visual and Select
" :smap  :snoremap :sunmap    Select
" :xmap  :xnoremap :xunmap    Visual
" :omap  :onoremap :ounmap    Operator-pending
" :map!  :noremap! :unmap!    Insert and Command-line
" :imap  :inoremap :iunmap    Insert
" :lmap  :lnoremap :lunmap    Insert, Command-line, Lang-Arg
" :cmap  :cnoremap :cunmap    Command-line
"}}}
