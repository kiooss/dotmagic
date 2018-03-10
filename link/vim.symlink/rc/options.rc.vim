"
" options
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" General {{{
" Explicitly tell vim that the terminal supports 256 colors
set t_Co=256

" Enable true color
if has('termguicolors')
  set termguicolors
endif
set shell=$SHELL
" use K to run a program to lookup the keyword under the cursor
set keywordprg=:help
set autoread                 " detect when a file is changeed
set mouse=nv                 " Disable mouse in command-line mode
set modeline                 " automatically setting options from modelines
set report=0                 " Don't report on line changes
set errorbells               " Trigger bell on error
set visualbell               " Use visual bell instead of beeping
set hidden                   " hide buffers when abandoned instead of unload
set fileformats=unix,dos,mac " Use Unix as the standard file type
set magic                    " For regular expressions turn magic on
set path=.,**                " Directories to search when using gf
set virtualedit=block        " Position cursor anywhere in visual block
set synmaxcol=1000           " Don't syntax highlight long lines
set formatoptions+=1         " Don't break lines after a one-letter word
set formatoptions-=t         " Don't auto-wrap text
if has('patch-7.3.541')
  set formatoptions+=j       " Remove comment leader when joining lines
endif

if has('vim_starting')
  scriptencoding utf-8
endif

" What to save for views:
set viewoptions-=options
set viewoptions+=slash,unix

" What to save in sessions:
set sessionoptions-=blank
set sessionoptions-=options
set sessionoptions-=globals
set sessionoptions-=folds
set sessionoptions-=help
set sessionoptions-=buffers
set sessionoptions+=tabpages

if has('clipboard')
  if has('unnamedplus')
    set clipboard& clipboard+=unnamedplus
  else
    set clipboard& clipboard+=unnamed
  endif
endif
" }}}
" Wildmenu {{{
if has('wildmenu')
  set wildmenu " enhanced command line completion
  set wildmode=list:longest,full
  set wildoptions=tagfile " Can supplement a tag in a command-line.
  set wildignorecase " case-insensitive filename completion
  set wildignore+=*.so,*.swp,.rsync_cache,cache,*.phar,autocomplete.php
  set wildignore+=.git,.hg,.svn,.stversions,*.pyc,*.spl,*.o,*.out,*~,%*
  set wildignore+=*.jpg,*.jpeg,*.png,*.gif,*.zip,**/tmp/**,*.DS_Store
  set wildignore+=**/node_modules/**,**/bower_modules/**,*/.sass-cache/*
  set wildignore+=application/vendor/**,**/vendor/ckeditor/**,media/vendor/**
  set wildignore+=__pycache__,*.egg-info
  set wildignore+=tmp,var,test,tests,Test,Tests
endif
" }}}
" Timing {{{
" ------
set notimeout       " don't timeout on mappings
set ttimeout        " do timeout on terminal key codes
set ttimeoutlen=50  " Time out on key codes
set updatetime=1000 " Idle time to write swap and trigger CursorHold
" }}}
" Tabs and Indents {{{
" ----------------
set textwidth=80    " Text width maximum chars before wrapping
set expandtab       " Expand tabs to spaces.
set tabstop=2       " The number of spaces a tab is
set softtabstop=2   " While performing editing operations
set shiftwidth=2    " Number of spaces to use in auto(indent)
set smarttab        " Tab insert blanks according to 'shiftwidth'
set autoindent      " Use same indenting on new lines
set smartindent     " Smart autoindenting on new lines
set shiftround      " Round indent to multiple of 'shiftwidth'

" }}}
" Searching {{{
" ---------
set ignorecase      " Search ignoring case
set smartcase       " Keep case when searching with *
set infercase       " Adjust case in insert completion mode
set incsearch       " Incremental search
set hlsearch        " Highlight search results
set wrapscan        " Searches wrap around the end of the file
set showmatch       " Jump to matching bracket
set matchpairs+=<:> " Add HTML brackets to pair matching
set matchtime=1     " Tenths of a second to show the matching paren
set cpoptions-=m    " showmatch will wait 0.5s or until a char is typed

" }}}
" Behavior {{{
" --------
" set nowrap                      " No wrap by default
" set linebreak                   " Break long lines at 'breakat'
" set breakat=\ \	;:,!?           " Long lines break chars
" set nostartofline               " Cursor in same column for few commands
" set whichwrap+=h,l,<,>,[,],~    " Move to following line on certain keys
set splitbelow splitright       " Splits open bottom right
set switchbuf=useopen,usetab    " Jump to the first open window in any tab
set switchbuf+=vsplit           " Switch buffer behavior to vsplit
set backspace=indent,eol,start  " Intuitive backspacing in insert mode
set diffopt=filler,iwhite       " Diff mode: show fillers, ignore white
set showfulltag                 " Show tag and tidy search in completion
set complete=.                  " No wins, buffs, tags, include scanning
set completeopt=menuone         " Show menu even for one item
set completeopt+=noselect       " Do not select a match in the menu
if has('patch-7.4.775')
  set completeopt+=noinsert
endif

if exists('+inccommand')
  set inccommand=nosplit
endif

if has('linebreak')
  set breakindent
  if exists('&breakindentopt')
    set breakindentopt=shift:2
  endif
  " let &showbreak='↳ ' " DOWNWARDS ARROW WITH TIP RIGHTWARDS (U+21B3, UTF-8: E2 86 B3)
  let &showbreak='↪ '
endif

" }}}
" Folds {{{
" -----

" FastFold
" Credits: https://github.com/Shougo/shougo-s-github
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

  if has('folding')
    if has('windows')
      set fillchars=vert:┃              " BOX DRAWINGS HEAVY VERTICAL (U+2503, UTF-8: E2 94 83)
      set fillchars+=fold:·             " MIDDLE DOT (U+00B7, UTF-8: C2 B7)
    endif
    set foldenable
    set foldmethod=marker
    set foldlevelstart=99               " start unfolded
    set foldnestmax=10 " deepest fold is 10 levels
    set foldtext=vimrc#foldtext()
    " set foldtext=FoldText()
  endif

" if has('folding')
"   set foldmethod=syntax
"   set foldlevelstart=99
"   set foldtext=FoldText()
" endif

" Improved Vim fold-text
" See: http://www.gregsexton.org/2011/03/improving-the-text-displayed-in-a-fold/
function! FoldText()
  " Get first non-blank line
  let fs = v:foldstart
  while getline(fs) =~? '^\s*$' | let fs = nextnonblank(fs + 1)
  endwhile
  if fs > v:foldend
    let line = getline(v:foldstart)
  else
    let line = substitute(getline(fs), '\t', repeat(' ', &tabstop), 'g')
  endif

  let w = winwidth(0) - &foldcolumn - (&number ? 8 : 0)
  let foldSize = 1 + v:foldend - v:foldstart
  let foldSizeStr = ' ' . foldSize . ' lines '
  let foldLevelStr = repeat('+--', v:foldlevel)
  let lineCount = line('$')
  let foldPercentage = printf('[%.1f', (foldSize*1.0)/lineCount*100) . '%] '
  let expansionString = repeat('.', w - strwidth(foldSizeStr.line.foldLevelStr.foldPercentage))
  return line . expansionString . foldSizeStr . foldPercentage . foldLevelStr
endfunction

" }}}
" Editor UI Appearance {{{
" --------------------
set noshowmode      " Don't show mode in cmd window
set shortmess=aoOTI " Shorten messages and don't show intro
set scrolloff=2     " Keep at least 2 lines above/below
set sidescrolloff=5 " Keep at least 5 lines left/right
set number          " show line numbers
set relativenumber  " show relative line numbers
set cursorline

set showcmd         " show incomplete commands
set cmdheight=1     " Height of the command line
set cmdwinheight=5  " Command-line lines
set laststatus=2    " Always show a status line

set invlist         " toggle invisible characters
set list            " Show hidden characters
" make the highlighting of tabs less annoying
highlight SpecialKey ctermbg=none
set listchars=tab:▸\ ,trail:•,eol:¬,extends:❯,precedes:❮,nbsp:⦸
" }}}

" Vim Directories {{{
" ---------------
set nobackup
set nowritebackup
set noswapfile

" History saving
set history=2000
if has('nvim')
  set shada=!,'300,<50,s10,h
else
  set viminfo=!,'300,<50,s10,h,n$VARPATH/viminfo
endif

if exists('$SUDO_USER')
  if has('nvim')
    set shada=
  else
    set viminfo=                      " don't create root-owned files
  endif
else
endif

if has("persistent_undo")
  if exists('$SUDO_USER')
    set noundofile
  else
    set undofile
    set undodir=$VARPATH/undo//
  endif
endif

" }}}

if !has('nvim')
  set ttyfast " faster redrawing
endif

" Exclude = from isfilename.
set isfname-==

" set tags place
set tags=./tags,tags;


" toggle paste mode
set pastetoggle=<F2>


if exists('&swapsync')
  set swapsync=                       " let OS sync swapfiles lazily
endif

"}}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => User Interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set title " set terminal title

set nolazyredraw " don't redraw while executing macros

set mat=2 " how many tenths of a second to blink

set t_vb=
set tm=500

"improve autocomplete menu color
highlight Pmenu ctermbg=238 gui=bold

" https://sunaku.github.io/vim-256color-bce.html
if &term =~ '256color'
  " disable Background Color Erase (BCE) so that color schemes
  " render properly when inside 256-color tmux and GNU screen.
  " see also http://snk.tuxfamily.org/log/vim-256color-bce.html
  set t_ut=
endif

