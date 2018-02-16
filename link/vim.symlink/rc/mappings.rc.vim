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

" s: Windows and buffers(High priority) "{{{
" The prefix key.
nnoremap [Window]   <Nop>
nmap     s [Window]
nnoremap <silent> [Window]p  :<C-u>vsplit<CR>:wincmd w<CR>
nnoremap <silent> [Window]o  :<C-u>only<CR>
nnoremap <silent> [Window]h  :wincmd H<CR>
nnoremap <silent> [Window]j  :wincmd J<CR>
nnoremap <silent> [Window]k  :wincmd K<CR>
nnoremap <silent> [Window]l  :wincmd L<CR>
nnoremap <silent> <Tab>      :wincmd w<CR>
nnoremap <silent><expr> q winnr('$') != 1 ? ':<C-u>close<CR>' : ""
"}}}

nnoremap <silent> <Leader>w :update<cr>
" close the preview window
nnoremap <silent> <Leader>hc :pc<cr>
nnoremap <silent> <Leader>q :q<cr>
nnoremap <silent> <Leader>z :qa!<cr>
" delete current buffer
nnoremap <silent> <Leader>b :<C-u>call kiooss#util#BufferDelete()<CR>
" delete other buffers except current one
nnoremap <silent> <Leader>B :<C-u>Bonly<CR>
nnoremap <Leader>x :x<cr>
nnoremap <Leader><Tab> <C-^>
nnoremap <Leader>p :pu<CR>
nnoremap <Leader>t :TagbarToggle<CR>
" nnoremap <silent> <Leader>y :<C-u>call system('nc localhost 8377', @")<CR>
nnoremap <silent> yy "*yy:let [@+,@"]=[@*,@*] <bar>
      \ call system('nc localhost 8377', @")<CR>

nnoremap j gj
nnoremap k gk

nnoremap g; g;zz
nnoremap g, g,zz

" format whole buffer
nnoremap <silent> g= :<C-u>call zvim#format()<CR>

nnoremap > >>
nnoremap < <<

" clear highlighted search
noremap <F3> :set hlsearch! hlsearch?<cr>

" Window moving
" nnoremap <C-j> <C-W>j<C-W>_
" nnoremap <C-k> <C-W>k<C-W>_
" nnoremap <C-h> <C-W>h<C-W>_
" nnoremap <C-l> <C-W>l<C-W>_

" Redraw.
" nnoremap <silent> <C-l>    :<C-u>redraw!<CR>

" simplify resizing splits
nnoremap <Down> <C-w>-
nnoremap <Up> <C-w>+
nnoremap <Left> <C-w><
nnoremap <Right> <C-w>>

" <tab> / <s-tab> | Circular windows navigation
" nnoremap <tab>   <c-w>w
" nnoremap <S-tab> <c-w>W

" better scroll
noremap <expr> <C-e> (line("w$") >= line('$') ? "j" : "3\<C-e>M")
noremap <expr> <C-y> (line("w0") <= 1         ? "k" : "3\<C-y>M")

" Smart <C-f>, <C-b>.
noremap <expr> <C-f> max([winheight(0) - 2, 1])
      \ . "\<C-d>" . (line('w$') >= line('$') ? "L" : "M")
noremap <expr> <C-b> max([winheight(0) - 2, 1])
      \ . "\<C-u>" . (line('w0') <= 1 ? "H" : "M")


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

" dein update
nnoremap <Leader>U :<C-u>call dein#update() <bar>
      \ call VimuxRunCommand("tail -f " . g:dein#install_log_filename)<CR>

" zz cyclically
nnoremap <expr> zz (winline() == (winheight(0)+1) / 2) ?
      \ 'zt' : (winline() == &scrolloff + 1) ? 'zb' : 'zz'

" If press l on fold, fold open.
nnoremap <expr> l foldclosed(line('.')) != -1 ? 'zo0' : 'l'
" If press l on fold, range fold open.
xnoremap <expr> l foldclosed(line('.')) != -1 ? 'zogv0' : 'l'


" git commit
nnoremap <Leader>gb :<C-u>Gblame<CR>
nnoremap gst :<C-u>Gina status --opener=10split<CR>
" nnoremap <Leader>ga :<C-u>Gina add .<CR>
" nnoremap <Leader>gU :<C-u>Gina reset -q %<CR>
nnoremap gca :<C-u>Gina commit -a -v<CR>
nnoremap gpu :<C-u>Gina push<CR>
nnoremap gdf :<C-u>Gina diff<CR>
nnoremap gaa :<C-u>Gina add -A<CR>
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

xnoremap <silent> y "*y:let [@+,@"]=[@*,@*] <bar>
      \ call system('nc localhost 8377', @")<CR>

xnoremap <silent> <Leader>gg :<C-u>call kiooss#util#GrepSource()<CR>

" use Ctrl+J,K to move sleceted lines.
xmap <C-j> ]egv=gv
xmap <C-k> [egv=gv

" stile select when indent in visual mode
vnoremap < <gv
vnoremap > >gv

" vnoremap <Leader><Space> zf

" Substitute.
xnoremap s :s//g<Left><Left>

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
