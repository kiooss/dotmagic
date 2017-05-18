"---------------------------------------------------------------------------
" Search:
"

" Ignore the case of normal letters.
set ignorecase
" If the search pattern contains upper case characters, override ignorecase
" option.
set smartcase

" Enable incremental search.
set incsearch
" Don't highlight search result.
set nohlsearch

" Searches wrap around the end of the file.
set wrapscan


"---------------------------------------------------------------------------
" Edit:
"

" Smart insert tab setting.
set smarttab " tab respects 'tabstop', 'shiftwidth', and 'softtabstop'
" Exchange tab to spaces.
set expandtab
" Substitute <Tab> with blanks.
" set tabstop=8
" Spaces instead <Tab>.
" set softtabstop=4
" Autoindent width.
set shiftwidth=4
" Round indent by shiftwidth.
set shiftround

" Enable smart indent.
set autoindent smartindent

" TODO:
" Disable modeline.
set modelines=0
set nomodeline

" Use clipboard register.

if (!has('nvim') || $DISPLAY != '') && has('clipboard')
  if has('unnamedplus')
     set clipboard& clipboard+=unnamedplus
  else
     set clipboard& clipboard+=unnamed
  endif
endif

" TODO:
" Enable backspace delete indent and newline.
set backspace=indent,eol,start

" TODO:
" Highlight <>.
set matchpairs+=<:>

" Display another buffer when current buffer isn't saved.
set hidden " current buffer can be put into background

" Search home directory path on cd.
" But can't complete.
"  set cdpath+=~

" TODO:
" Enable folding.
set foldenable
" set foldmethod=expr
set foldmethod=marker
" Show folding level.
set foldcolumn=1
set fillchars=vert:\|
set commentstring=%s

" FastFold
autocmd MyAutoCmd TextChangedI,TextChanged *
      \ if &l:foldenable && &l:foldmethod !=# 'manual' |
      \   let b:foldmethod_save = &l:foldmethod |
      \   let &l:foldmethod = 'manual' |
      \ endif
autocmd MyAutoCmd BufWritePost *
      \ if &l:foldmethod ==# 'manual' && exists('b:foldmethod_save') |
      \   let &l:foldmethod = b:foldmethod_save |
      \   execute 'normal! zx' |
      \ endif

if exists('*FoldCCtext')
  " Use FoldCCtext().
  set foldtext=FoldCCtext()
endif

" TODO:
" Use vimgrep.
" set grepprg=internal
" Use grep.
set grepprg=grep\ -inH

" TODO:
" Exclude = from isfilename.
set isfname-==

" TODO:
" Keymapping timeout.
" set timeout timeoutlen=3000 ttimeoutlen=100
set notimeout          " don't timeout on mappings
set ttimeout           " do timeout on terminal key codes
set timeoutlen=100     " timeout after 100 msec

" TODO:
" CursorHold time.
set updatetime=1000

" TODO:
" Set swap directory.
set directory-=.

" TODO:
" Set undofile.
" set undofile
" let &g:undodir = &directory

" Enable virtualedit in visual block mode.
set virtualedit=block

" Set keyword help.
set keywordprg=:help

" Check timestamp more for 'autoread'.
autocmd MyAutoCmd WinEnter * checktime

" Disable paste.
autocmd MyAutoCmd InsertLeave *
      \ if &paste | setlocal nopaste | echo 'nopaste' | endif |
      \ if &l:diff | diffupdate | endif

" Update diff.
autocmd MyAutoCmd InsertLeave * if &l:diff | diffupdate | endif

" Make directory automatically.
" --------------------------------------
" http://vim-users.jp/2011/02/hack202/

autocmd MyAutoCmd BufWritePre *
      \ call s:mkdir_as_necessary(expand('<afile>:p:h'), v:cmdbang)
function! s:mkdir_as_necessary(dir, force) abort
  if !isdirectory(a:dir) && &l:buftype == '' &&
        \ (a:force || input(printf('"%s" does not exist. Create? [y/N]',
        \              a:dir)) =~? '^y\%[es]$')
    call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
  endif
endfunction

" Use autofmt.
set formatexpr=autofmt#japanese#formatexpr()

" Use blowfish2
" https://dgl.cx/2014/10/vim-blowfish
" if has('cryptv')
  " It seems 15ms overhead.
  "  set cryptmethod=blowfish2
" endif

" If true Vim master, use English help file.
set helplang& helplang=en,ja

" Default home directory.
let t:cwd = getcwd()

"---------------------------------------------------------------------------
" View:
"

" Show line number.
"set number
" Show <TAB> and <CR>
set list
if IsWindows()
   set listchars=tab:>-,trail:-,extends:>,precedes:<
else
   set listchars=tab:▸\ ,trail:-,extends:»,precedes:«,nbsp:%
endif
" Always display statusline.
set laststatus=2
" Height of command line.
set cmdheight=2
" Not show command on statusline.
set noshowcmd
" Show title.
set title
" Title length.
set titlelen=95
" Title string.
let &g:titlestring="
      \ %{expand('%:p:~:.')}%(%m%r%w%)
      \ %<\(%{WidthPart(
      \ fnamemodify(&filetype ==# 'vimfiler' ?
      \ substitute(b:vimfiler.current_dir, '.\\zs/$', '', '') : getcwd(), ':~'),
      \ &columns-len(expand('%:p:.:~')))}\) - VIM"
" Disable tabline.
set showtabline=0

" Set statusline.
let &g:statusline="%{winnr('$')>1?'['.winnr().'/'.winnr('$')"
      \ . ".(winnr('#')==winnr()?'#':'').']':''}\ "
      \ . "%{(&previewwindow?'[preview] ':'').expand('%:t')}"
      \ . "\ %=%{(winnr('$')==1 || winnr('#')!=winnr()) ?
      \ '['.(&filetype!=''?&filetype.',':'')"
      \ . ".(&fenc!=''?&fenc:&enc).','.&ff.']' : ''}"
      \ . "%m%{printf('%'.(len(line('$'))+2).'d/%d',line('.'),line('$'))}"

" Turn down a long line appointed in 'breakat'
set linebreak
set showbreak=\
set breakat=\ \	;:,!?
" Wrap conditions.
set whichwrap+=h,l,<,>,[,],b,s,~
if exists('+breakindent')
  set breakindent
  set wrap
else
  set nowrap
endif

" Do not display the greetings message at the time of Vim start.
set shortmess=aTI

" Do not display the completion messages
set noshowmode
if has('patch-7.4.314')
  set shortmess+=c
else
  autocmd MyAutoCmd VimEnter *
        \ highlight ModeMsg guifg=bg guibg=bg |
        \ highlight Question guifg=bg guibg=bg
endif

" Do not display the edit messages
if has('patch-7.4.1570')
  set shortmess+=F
endif

" Don't create backup.
set nowritebackup
set nobackup
set noswapfile
set backupdir-=.

" Disable bell.
set t_vb=
set novisualbell
set belloff=all

" Display candidate supplement.
set nowildmenu
set wildmode=list:longest,full
" Increase history amount.
set history=1000
" Display all the information of the tag by the supplement of the Insert mode.
set showfulltag
" Can supplement a tag in a command-line.
set wildoptions=tagfile

if has('nvim')
  set shada=!,'300,<50,s10,h
else
  set viminfo=!,'300,<50,s10,h
endif

" Disable menu
let g:did_install_default_menus = 1

" Completion setting.
set completeopt=menuone
if has('patch-7.4.775')
  set completeopt+=noinsert
endif
" Don't complete from other buffer.
set complete=.
" Set popup menu max height.
set pumheight=20

" Report changes.
set report=0

" Maintain a current line at the time of movement as much as possible.
set nostartofline

" Splitting a window will put the new window below the current one.
set splitbelow
" Splitting a window will put the new window right the current one.
set splitright
" Set minimal width for current window.
set winwidth=30
" Set minimal height for current window.
" set winheight=20
set winheight=1
" Set maximam maximam command line window.
set cmdwinheight=5
" No equal window size.
set noequalalways

" Adjust window size of preview and help.
set previewheight=8
set helpheight=12

" faster redrawing
set ttyfast

" When a line is long, do not omit it in @.
set display=lastline
" Display an invisible letter with hex format.
"set display+=uhex

function! WidthPart(str, width) abort "{{{
  if a:width <= 0
    return ''
  endif
  let ret = a:str
  let width = strwidth(a:str)
  while width > a:width
    let char = matchstr(ret, '.$')
    let ret = ret[: -1 - len(char)]
    let width -= strwidth(char)
  endwhile

  return ret
endfunction"}}}

" For conceal.
set conceallevel=2 concealcursor=niv

" set colorcolumn=79



"""XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX



set autoread " detect when a file is changeed

" make backspace behave in a sane manner
set backspace=start,indent,eol

" Tab control
set tabstop=4 " the visible width of tabs
set softtabstop=4 " edit as if the tabs are 4 characters wide
"set completeopt+=longest

" code folding settings
" set foldmethod=syntax " fold based on indent
" set foldnestmax=10 " deepest fold is 10 levels
" set nofoldenable " don't fold by default
" set foldlevel=1
" set foldlevelstart=99

" set tags place
set tags=./tags,tags;

" remove the buffer limit when dong yank to copy and past in VIM
set viminfo='100,h

set cursorline

set path+=**

" toggle paste mode
set pastetoggle=<F2>
set showmode

set laststatus=2

set wildignore+=*/tmp/*,*.so,*.swp,*.zip,.rsync_cache,.svn,.git,cache,*.phar,autocomplete.php,Tests,tests,Test,test,tmp

" save in readonly mode
cnoreabbrev w!! w !sudo tee > /dev/null %

" switch syntax highlighting on
syntax on

set so=7 " set 7 lines to the cursors - when moving vertical
set showcmd " show incomplete commands
set noshowmode " don't show which mode disabled for PowerLine
set wildmenu " enhanced command line completion
"set wildmode=list:longest " complete files like a shell
set wildmode=longest:list,full
set scrolloff=3 " lines of text around cursor
set shell=$SHELL
set cmdheight=1 " command bar height

set title " set terminal title

" Searching
set hlsearch
set nolazyredraw " don't redraw while executing macros

set magic " Set magic on, for regex

set wildignorecase " case-insensitive filename completion

set showmatch " show matching braces
set mat=2 " how many tenths of a second to blink

" error bells
set noerrorbells
set visualbell
set t_vb=
set tm=500

" set number " show line numbers
" set relativenumber " show relative line numbers
set number " show the current line number"


setglobal fenc=utf-8
"set fileencodings=iso-2022-jp,euc-jp,sjis,utf-8
set fencs=utf-8,euc-jp,sjis
set enc=utf-8
set tenc=utf-8

"improve autocomplete menu color
highlight Pmenu ctermbg=238 gui=bold

" toggle invisible characters
set invlist
set list
set listchars=tab:▸\ ,extends:❯,precedes:❮
" make the highlighting of tabs less annoying
highlight SpecialKey ctermbg=none
set listchars=tab:▸\ ,eol:¬
set showbreak=↪

scriptencoding utf-8

" https://sunaku.github.io/vim-256color-bce.html
if &term =~ '256color'
  " disable Background Color Erase (BCE) so that color schemes
  " render properly when inside 256-color tmux and GNU screen.
  " see also http://snk.tuxfamily.org/log/vim-256color-bce.html
  set t_ut=
endif

if has("gui_macvim")
    set guifont=Droid\ Sans\ Mono\ for\ Powerline\ Nerd\ Font\ Complete\:h14
endif

let base16colorspace=256  " Access colors present in 256 colorspace"
set t_Co=256 " Explicitly tell vim that the terminal supports 256 colors"

if has('termguicolors')
    set termguicolors
endif

" set background=light
set background=dark

" hard|medium|soft
let g:gruvbox_contrast_dark="hard"
let g:gruvbox_contrast_light="hard"
colorscheme gruvbox

" colorscheme srcery
" let g:solarized_visibility="low"
" let g:solarized_termtrans=1
" colorscheme solarized8_dark_high
" colorscheme solarized8_dark

" colorscheme molokai
" colorscheme PaperColor

set foldmethod=manual " solve autocomplete slow problem
set complete-=i
set complete+=k

" no preview window
set completeopt-=preview

"set columns=100
"set lines=70

" highlight conflicts
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups, and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"{{{
"set nobackup
"set nowritebackup
"set noswapfile
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
"}}}
