"==============================================================================
" mappings.vim---Mapping settings.
" => Yang Yang
"==============================================================================

"==============================================================================
" Normal Mode Key Mappings {{{
"==============================================================================
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
" nnoremap  [Space]   <Nop>
" nmap  <Space>   [Space]

" Focus the current fold by closing all others
nnoremap <CR> zMza

nnoremap <silent> <ESC><ESC> :<C-u>set nopaste nohlsearch<CR>

" Change current word in a repeatable manner
" nnoremap cn *``cgn
" nnoremap cN *``cgN

" Change selected word in a repeatable manner
" vnoremap <expr> cn "y/\\V\<C-r>=escape(@\", '/')\<CR>\<CR>" . "``cgn"
" vnoremap <expr> cN "y/\\V\<C-r>=escape(@\", '/')\<CR>\<CR>" . "``cgN"

" s: Windows and buffers(High priority) "{{{
" The prefix key.
nnoremap [Window]   <Nop>
nmap     s [Window]
nnoremap <silent> [Window]p  :<C-u>vsplit<CR>:wincmd w<CR>
nnoremap <silent> [Window]o  :<C-u>only<CR>
nnoremap <silent> [Window]b  :b#<CR>
nnoremap <silent> [Window]t  :tabnew<CR>
nnoremap <silent> [Window]c  :close<CR>
nnoremap <silent> [Window]h  :wincmd H<CR>
nnoremap <silent> [Window]j  :wincmd J<CR>
nnoremap <silent> [Window]k  :wincmd K<CR>
nnoremap <silent> [Window]l  :wincmd L<CR>
" Split current buffer, go to previous window and previous buffer
nnoremap <silent> [Window]sv :split<CR>:wincmd p<CR>:e#<CR>
nnoremap <silent> [Window]sp :vsplit<CR>:wincmd p<CR>:e#<CR>
" close the preview window
nnoremap <silent> [Window]z  :wincmd z<CR>
nnoremap <silent> <Tab>      :wincmd w<CR>
" nnoremap <silent><expr> q winnr('$') != 1 ? ':<C-u>close<CR>' : ""
" nnoremap <silent> q :call kiooss#util#SmartQuit()<CR>
"}}}

nnoremap <silent> [Window]w :update <bar> GitGutter<CR>
nnoremap <silent> <Leader>w :update <bar> GitGutter<CR>
nnoremap <silent> <Leader>q :q<cr>
nnoremap <silent> <Leader>z :qa!<cr>
" delete current buffer
nnoremap <silent> <Leader>b :<C-u>call kiooss#util#BufferDelete()<CR>
" delete other buffers except current one
nnoremap <silent> <Leader>B :<C-u>Bonly<CR>
nnoremap <Leader>x :x<cr>
nnoremap <Leader><Tab> <C-^>
nnoremap <Leader>p "0p
nnoremap <Leader>/ /

" ----------------------------------------------------------------------------
" <Leader>c Close quickfix/location/preview window
" ----------------------------------------------------------------------------
nnoremap <leader>c :cclose<bar>lclose<bar>pclose<cr>

" better redraw
nnoremap <c-l> :nohlsearch<cr>:diffupdate<cr>:syntax sync fromstart<cr>:GitGutter<cr><c-l>

nnoremap <silent> <Leader>hp :call zvim#previewHunkToggle()<CR>

nnoremap <silent> j gj
nnoremap <silent> k gk

nnoremap <silent> gj j
nnoremap <silent> gk k

nnoremap <silent> g; g;zvzz
nnoremap <silent> g, g,zvzz

" Better x with black hole register "_
nnoremap x "_x

nnoremap Y y$

" format whole buffer
nnoremap <silent> g= :<C-u>call zvim#format()<CR>

" nnoremap > >>
" nnoremap < <<

" Window moving
" nnoremap <C-j> <C-W>j<C-W>_
" nnoremap <C-k> <C-W>k<C-W>_
" nnoremap <C-h> <C-W>h<C-W>_
" nnoremap <C-l> <C-W>l<C-W>_

" simplify resizing splits
" nnoremap <Down> <C-w>-
" nnoremap <Up> <C-w>+
" nnoremap <Left> <C-w><
" nnoremap <Right> <C-w>>

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

" nnoremap p gp

" disable EX mode
nnoremap Q q

" Toggle folds
nnoremap <silent> <leader><Space> @=(foldlevel('.')?'za':"\<Space>")<CR>

" +/-: Increment number
" nnoremap + <c-a>
" nnoremap - <c-x>

" dein update
nnoremap <Leader>U :<C-u>call dein#update() <bar>
      \ call termopen("tail -f " . g:dein#install_log_filename)<CR>

" zz cyclically
nnoremap <expr> zz (winline() == (winheight(0)+1) / 2) ?
      \ 'zt' : (winline() == &scrolloff + 1) ? 'zb' : 'zz'

" If press l on fold, fold open.
nnoremap <expr> l foldclosed(line('.')) != -1 ? 'zo0' : 'l'
" If press l on fold, range fold open.
xnoremap <expr> l foldclosed(line('.')) != -1 ? 'zogv0' : 'l'

nnoremap <silent> ,<Space> :<C-u>silent! keeppatterns %substitute/\s\+$//e<CR>

nnoremap <silent> g0 :<C-u>tabfirst<CR>
nnoremap <silent> g$ :<C-u>tablast<CR>
nnoremap <silent> gr :<C-u>tabprevious<CR>

nnoremap <c-o>  <c-o>zvzz

" git mappings
nnoremap [Git]   <Nop>
nmap     [Window]g [Git]
nnoremap <silent> [Git]bl :<C-u>Gblame<CR>
nnoremap <silent> [Git]st :<C-u>Gstatus<CR>
nnoremap <silent> [Git]cm :<C-u>Gcommit -v<CR>
" nnoremap [Git]ga :<C-u>Gina add .<CR>
" nnoremap [Git]gU :<C-u>Gina reset -q %<CR>
nnoremap [Git]ca :<C-u>Gina commit -a -v<CR>
nnoremap [Git]pu :<C-u>Gina push<CR>
nnoremap [Git]df :<C-u>Gina diff<CR>
nnoremap [Git]aa :<C-u>Gina add -A<CR>

if has('mac')
  " Open the macOS dictionary on current word
  nmap <Leader>? :!open dict://<cword><CR><CR>
endif

" Append modeline to EOF {{{
nnoremap <silent> <Leader>ml :call <SID>append_modeline()<CR>

" Append modeline after last line in buffer
" See: http://vim.wikia.com/wiki/Modeline_magic
function! s:append_modeline() "{{{
  let l:modeline = printf(' vim: set ts=%d sw=%d tw=%d %set :',
        \ &tabstop, &shiftwidth, &textwidth, &expandtab ? '' : 'no')
  let l:modeline = substitute(&commentstring, '%s', l:modeline, '')
  call append(line('$'), l:modeline)
endfunction "}}}
" }}}
"}}}
"==============================================================================
" Insert Mode Key Mappings {{{
"==============================================================================
" escaping
inoremap jk <esc>
inoremap j<Space>     j

inoremap <C-c> <Esc>`^

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

imap <a-o> <c-o>o

" https://gist.github.com/tpope/287147
inoremap <silent> <Bar>   <Bar><Esc>:call <SID>align()<CR>a
function! s:align()
  let p = '^\s*|\s.*\s|\s*$'
  if exists(':Tabularize') && getline('.') =~# '^\s*|' && (getline(line('.')-1) =~# p || getline(line('.')+1) =~# p)
    let column = strlen(substitute(getline('.')[0:col('.')],'[^|]','','g'))
    let position = strlen(matchstr(getline('.')[0:col('.')],'.*|\s*\zs.*'))
    Tabularize/|/l1
    normal! 0
    call search(repeat('[^|]*|',column).'\s\{-\}'.repeat('.',position),'ce',line('.'))
  endif
endfunction
" }}}
"==============================================================================
" Command Mode Key Mappings {{{
"==============================================================================
" jk | Escaping!
cnoremap jk             <C-c>
cnoremap <expr> j
      \ getcmdline()[getcmdpos()-2] ==# 'j' ? "\<BS>\<C-c>" : 'j'
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
" Visual Mode Key Mappings {{{
"=============================================================================
" if (!has('nvim') || $DISPLAY != '') && has('clipboard')
"   xnoremap <silent> y "*y:let [@+,@"]=[@*,@*]<CR>
" endif

" xnoremap <silent> y "*y:let [@+,@"]=[@*,@*] <bar>
"       \ call system('nc localhost 8377', @")<CR>

" xnoremap <silent> <Leader>gg :<C-u>call kiooss#util#GrepSource()<CR>

" use up and down to move sleceted lines.
xmap <Up> ]egv=gv
xmap <Down> [egv=gv

" stile select when indent in visual mode
vnoremap < <gv
vnoremap > >gv

" vnoremap <Leader><Space> zf

" Substitute.
xnoremap s :s//g<Left><Left>

xnoremap <Leader>s :<C-u>call kiooss#util#ReplaceDelimiter()<CR>

" C-r: Easier search and replace
xnoremap <C-r> :<C-u>call <SID>get_selection('/')<CR>:%s/\V<C-R>=@/<CR>//gc<Left><Left><Left>

" Returns visually selected text
function! s:get_selection(cmdtype) "{{{
  let temp = @s
  normal! gv"sy
  let @/ = substitute(escape(@s, '\'.a:cmdtype), '\n', '\\n', 'g')
  let @s = temp
endfunction "}}}
"}}}
"==============================================================================

" vim: set ts=2 sw=2 tw=80 et fdm=marker fdl=0:
