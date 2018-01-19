"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set autoread " detect when a file is changeed

" set mouse behavior
if has('mouse')
  " set mouse=a
  " set ttymouse=xterm2
endif

" Use clipboard register.
if (!has('nvim') || $DISPLAY != '') && has('clipboard')
  if has('unnamedplus')
     set clipboard& clipboard+=unnamedplus
  else
     set clipboard& clipboard+=unnamed
  endif
endif

" faster redrawing
set ttyfast

set notimeout          " don't timeout on mappings
set ttimeout           " do timeout on terminal key codes
set timeoutlen=100     " timeout after 100 msec

" make backspace behave in a sane manner
set backspace=start,indent,eol

set modeline

" Tab control
" set noexpandtab " insert tabs rather than spaces for <Tab>
set expandtab
set smarttab " tab respects 'tabstop', 'shiftwidth', and 'softtabstop'
set tabstop=4 " the visible width of tabs
set softtabstop=4 " edit as if the tabs are 4 characters wide
set shiftwidth=4 " number of spaces to use for indent and unindent
set shiftround " round indent to a multiple of 'shiftwidth'

set complete-=i
set complete+=k
set completeopt+=longest

" code folding settings
" set foldmethod=syntax " fold based on indent
" set foldnestmax=10 " deepest fold is 10 levels
" set nofoldenable " don't fold by default
" set foldlevel=1
if has('folding')
  if has('windows')
    set fillchars=vert:┃              " BOX DRAWINGS HEAVY VERTICAL (U+2503, UTF-8: E2 94 83)
    set fillchars+=fold:·             " MIDDLE DOT (U+00B7, UTF-8: C2 B7)
  endif
  " show folding level
  " set foldcolumn=1
  " set foldmethod=indent               " not as cool as syntax, but faster
  set foldmethod=marker
  " set foldlevel=1
  " set foldlevelstart=99               " start unfolded
  set foldtext=vimrc#foldtext()
endif


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

set wildignore+=*/tmp/*,*.so,*.swp,*.zip,.rsync_cache,.svn,.git
set wildignore+=cache,*.phar,autocomplete.php,Tests,tests,Test,test,tmp

" set keyword help.
" use K to run a program to lookup the keyword under the cursor
set keywordprg=:help

" save in readonly mode
cnoreabbrev w!! w !sudo tee > /dev/null %

if exists('&swapsync')
  set swapsync=                       " let OS sync swapfiles lazily
endif

if has('syntax')
  set synmaxcol=200                   " don't bother syntax highlighting long lines
endif

set updatecount=80                    " update swapfiles every 80 typed chars
set updatetime=2000                   " CursorHold interval

if v:version > 703 || v:version == 703 && has('patch541')
  set formatoptions+=j                " remove comment leader when joining comment lines
endif
"}}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => User Interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"{{{
set so=7 " set 7 lines to the cursors - when moving vertical
set hidden " current buffer can be put into background
set showcmd " show incomplete commands
set noshowmode " don't show which mode disabled for PowerLine
set wildmenu " enhanced command line completion
"set wildmode=list:longest " complete files like a shell
" set wildmode=longest:list,full
set wildmode=list:longest,full
" set wildmode=longest:full,full        " shell-like autocomplete to unambiguous portion
set scrolloff=3 " lines of text around cursor
set shell=$SHELL
set cmdheight=1 " command bar height

" Display all the information of the tag by the supplement of the Insert mode.
set showfulltag
" Can supplement a tag in a command-line.
set wildoptions=tagfile

" Report changes.
set report=0

set title " set terminal title

" Searching
set ignorecase " case insensitive searching
set smartcase " case-sensitive if expresson contains a capital letter
set hlsearch
set incsearch " set incremental search, like modern browsers
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

set number " show line numbers
set relativenumber " show relative line numbers

set autoindent " automatically set indent of new line
set smartindent

setglobal fenc=utf-8
"set fileencodings=iso-2022-jp,euc-jp,sjis,utf-8
set fencs=utf-8,euc-jp,sjis
set enc=utf-8
set tenc=utf-8

" Highlight <>.
set matchpairs+=<:>

"improve autocomplete menu color
highlight Pmenu ctermbg=238 gui=bold

" toggle invisible characters
set invlist
set list
" make the highlighting of tabs less annoying
highlight SpecialKey ctermbg=none
set listchars=tab:▸\ ,trail:•,eol:¬,extends:❯,precedes:❮,nbsp:⦸

if has('linebreak')
  set breakindent
  if exists('&breakindentopt')
    set breakindentopt=shift:2
  endif
  " let &showbreak='↳ ' " DOWNWARDS ARROW WITH TIP RIGHTWARDS (U+21B3, UTF-8: E2 86 B3)
  let &showbreak='↪ '
endif

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

set t_Co=256 " Explicitly tell vim that the terminal supports 256 colors"

if has('termguicolors')
    set termguicolors
endif

set textwidth=80

" set foldmethod=manual " solve autocomplete slow problem

" no preview window
set completeopt-=preview

" set columns=100
" set lines=70

" Splitting a window will put the new window below the current one.
set splitbelow
" Splitting a window will put the new window right the current one.
set splitright

" highlight conflicts
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'
"}}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups, and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"{{{
if exists('$SUDO_USER')
  set nobackup                        " don't create root-owned files
  set nowritebackup                   " don't create root-owned files
else
  set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
endif

if exists('$SUDO_USER')
  set noswapfile                      " don't create root-owned files
else
  set directory=~/.vim-tmp//,~/.tmp//,~/tmp//,/var/tmp//,/tmp//
endif

if has('viminfo')
  if exists('$SUDO_USER')
    set viminfo=                      " don't create root-owned files
  else
    if isdirectory(expand('~/.vim-tmp'))
      set viminfo+=n~/.vim-tmp/viminfo
    endif

    if !empty(glob('~/.vim-tmp/viminfo'))
      if !filereadable(expand('~/.vim-tmp/viminfo'))
        echoerr 'warning: ~/.vim-tmp/viminfo exists but is not readable'
      endif
    endif
  endif
endif
"}}}
