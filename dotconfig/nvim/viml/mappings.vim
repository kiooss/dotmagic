"==============================================================================
" mappings.vim---Mapping settings.
" => Yang Yang
" vim: set sw=2 ts=2 sts=2 et tw=78 foldmarker={{,}} foldmethod=marker foldlevel=0:
"==============================================================================

" Use <Leader> in global plugin.
let g:mapleader = "\<Space>"
" Use <LocalLeader> in filetype plugin.
let g:maplocalleader = ';'

nnoremap <silent> <leader>      :<c-u>WhichKey '<Space>'<CR>
nnoremap <silent> <localleader> :<c-u>WhichKey  ';'<CR>
" nnoremap <silent> g             :<c-u>WhichKey  'g'<CR>
nnoremap <silent> ]             :<c-u>WhichKey  ']'<CR>
nnoremap <silent> [             :<c-u>WhichKey  '['<CR>

vnoremap <silent> <leader>      :<c-u>WhichKeyVisual '<Space>'<CR>
vnoremap <silent> <localleader> :<c-u>WhichKeyVisual  ';'<CR>
" vnoremap <silent> g             :<c-u>WhichKeyVisual  'g'<CR>
vnoremap <silent> ]             :<c-u>WhichKeyVisual  ']'<CR>
vnoremap <silent> [             :<c-u>WhichKeyVisual  '['<CR>

"==============================================================================
" Normal Mode Key Mappings {{{

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

" s: Windows and buffers(High priority)
" The prefix key.
nnoremap [Window]   <Nop>
" nmap     s [Window]
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

" Tab to swich windows
nnoremap <silent> <Tab>      :wincmd w<CR>
" vsplit all buffers
" nnoremap <leader>- :<C-u>vertical sball<CR>
nnoremap <leader>e :<C-u>tab sball<CR>

nnoremap <silent> <Leader>- :vsplit<CR>:wincmd p<CR>:e#<CR>
" switch tabs
" nmap <leader>1 1gt
" nmap <leader>2 2gt
" nmap <leader>3 3gt
" nmap <leader>4 4gt
" nmap <leader>5 5gt
" nmap <leader>6 6gt
" nmap <leader>7 7gt
" nmap <leader>8 8gt
" nmap <leader>9 9gt

" Focus the current fold by closing all others
nnoremap <CR> zMza

" Toggle folds
" nnoremap <silent> + @=(foldlevel('.')?'za':"+")<CR>
nnoremap <silent> <leader><Space> @=(foldlevel('.')?'za':"\<Space>")<CR>

nnoremap <silent> <ESC><ESC> :<C-u>set nopaste nohlsearch<bar>cclose<bar>lclose<bar>pclose<cr>

" Change current word in a repeatable manner
" nnoremap <leader>cn *``cgn
" nnoremap <leader>cN *``cgN

" Change selected word in a repeatable manner
vnoremap <expr> <leader>cn "y/\\V\<C-r>=escape(@\", '/')\<CR>\<CR>" . "``cgn"
vnoremap <expr> <leader>cN "y/\\V\<C-r>=escape(@\", '/')\<CR>\<CR>" . "``cgN"

vnoremap <leader>64 c<c-r>=system('base64 --decode', @")<cr><esc>

nnoremap gp :silent !prettier --write %<CR>

nnoremap <silent> <Leader>w :update <bar> GitGutter<CR>
nnoremap <silent> <Leader>q :q<cr>
nnoremap <silent> <Leader>z :qa!<cr>
" delete other buffers except current one
nnoremap <silent> <Leader>B :<C-u>Bonly<CR>
nnoremap <Leader>x :x<cr>
nnoremap <Leader><Tab> <C-^>
nnoremap <Leader>p "0p
nnoremap <Leader>/ /

" better redraw
nnoremap <c-l> :nohlsearch<cr>:diffupdate<cr>:syntax on<cr>:GitGutter<cr><c-l>

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
nnoremap <silent> g= :<C-u>call <SID>format()<CR>

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
" noremap <expr> <C-f> max([winheight(0) - 2, 1])
"       \ . "\<C-d>" . (line('w$') >= line('$') ? "L" : "M")
" noremap <expr> <C-b> max([winheight(0) - 2, 1])
"       \ . "\<C-u>" . (line('w0') <= 1 ? "H" : "M")


" move to beginning/end of line
nnoremap B ^
nnoremap E $

" Tags
nnoremap g] g<C-]>
nnoremap g[ :pop<cr>

" nnoremap p gp

" disable EX mode
nnoremap Q q

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
nnoremap <silent> <leader>sb :<C-u>Gblame<CR>
nnoremap <silent> <leader>st :<C-u>Gstatus<CR>
nnoremap <silent> <leader>d :<C-u>Gstatus<CR>
nnoremap <silent> <leader>sc :<C-u>Gcommit -v<CR>
nnoremap <silent> <leader>sa :<C-u>Git add -A<CR>
nnoremap <silent> <leader>sd :<C-u>Gdiff<CR>
nnoremap <silent> <leader>sU :<C-u>Git reset -q %<CR>
nnoremap <silent> <leader>sp :<C-u>Gpush<CR>
nnoremap <silent> <leader>sl V:<c-u>call OpenCurrentFileInGithub()<cr>
nnoremap <silent> <leader>sk V:<c-u>call OpenCurrentFileInGitee()<cr>

if has('mac')
  " Open the macOS dictionary on current word
  nmap <Leader>? :!open dict://<cword><CR><CR>
endif

" toggle number & list
nnoremap <leader>t :call <SID>NumberToggle()<CR>

nnoremap <silent> q :Sayonara<cr>

" util {{{
nnoremap <silent> <Leader>us :vsplit<CR>:wincmd p<CR>:e#<CR>
nnoremap <silent> <Leader>ut :call <SID>timestamp_to_datetime()<CR>
" append modeline to EOF
nnoremap <silent> <Leader>um :call <SID>append_modeline()<CR>
" }}}

"}}}
"==============================================================================
" Insert Mode Key Mappings {{{
"==============================================================================
" escaping
inoremap jk <esc>
inoremap jj <esc>
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

" conflicts with coc
" inoremap {%     {%  %}<Left><Left><Left>
" inoremap <%     <%  %><Left><Left><Left>

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

" use up and down to move sleceted lines.
xmap <Up> ]egv=gv
xmap <Down> [egv=gv

" stile select when indent in visual mode
vnoremap < <gv
vnoremap > >gv

" vnoremap <Leader><Space> zf

" Substitute.
xnoremap s :s//g<Left><Left>

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

" functions {{
function! s:NumberToggle()
  if(&number == 1) | set nu! | set rnu! | set list! | else | set rnu | set nu | set list |endif
endfunction

" Append modeline after last line in buffer
" See: http://vim.wikia.com/wiki/Modeline_magic
function! s:append_modeline()
  let l:modeline = printf(' vim: set ts=%d sw=%d tw=%d %set :',
        \ &tabstop, &shiftwidth, &textwidth, &expandtab ? '' : 'no')
  let l:modeline = substitute(&commentstring, '%s', l:modeline, '')
  call append(line('$'), l:modeline)
endfunction

function! s:timestamp_to_datetime()
  echo strftime('%Y-%m-%d %H:%M:%S', expand('<cword>'))
endfunction

function! s:format() abort
  let save_cursor = getpos('.')
  normal! gg=G
  call setpos('.', save_cursor)
endfunction

function! OpenCurrentFileInGithub()
  let file_dir = expand('%:h')
  let git_root = system('cd ' . file_dir . '; git rev-parse --show-toplevel | tr -d "\n"')
  let file_path = substitute(expand('%:p'), git_root . '/', '', '')
  let branch = system('git symbolic-ref --short -q HEAD | tr -d "\n"')
  let git_remote = system('cd ' . file_dir . '; git remote get-url origin')
  let repo_path = matchlist(git_remote, ':\(.*\)\.')[1]
  let url = 'https://github.com/' . repo_path . '/blob/' . branch . '/' . file_path
  let first_line = getpos("'<")[1]
  let url .= '#L' . first_line
  let last_line = getpos("'>")[1]
  if last_line != first_line | let url .= '-L' . last_line | endif
  if has('mac')
    call system('open ' . url)
  else
    echohl WarningMsg
    echon  url
    echohl None
  endif
endfunction

function! OpenCurrentFileInGitee()
  let file_dir = expand('%:h')
  let git_root = system('cd ' . file_dir . '; git rev-parse --show-toplevel | tr -d "\n"')
  let file_path = substitute(expand('%:p'), git_root . '/', '', '')
  let branch = system('git symbolic-ref --short -q HEAD | tr -d "\n"')
  let git_remote = system('cd ' . file_dir . '; git remote get-url origin')
  let repo_path = matchlist(git_remote, ':\(.*\)\.')[1]
  let url = 'https://gitee.com/' . repo_path . '/blob/' . branch . '/' . file_path
  let first_line = getpos("'<")[1]
  let url .= '#L' . first_line
  let last_line = getpos("'>")[1]
  if last_line != first_line | let url .= '-L' . last_line | endif
  if has('mac')
    call system('open ' . url)
  else
    echohl WarningMsg
    echon  url
    echohl None
  endif
endfunction
" }}
