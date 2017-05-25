"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set autoread " detect when a file is changeed

" set mouse behavior
if has('mouse')
  " set mouse=a
  " set ttymouse=xterm2
endif

if has('nvim')
    " set clipboard=unnamedplus
else
    set clipboard=unnamed
endif

" faster redrawing
set ttyfast

set notimeout          " don't timeout on mappings
set ttimeout           " do timeout on terminal key codes
set timeoutlen=100     " timeout after 100 msec

" make backspace behave in a sane manner
set backspace=start,indent,eol

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

"}}}

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => User Interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"{{{

" switch syntax highlighting on
syntax on

set so=7 " set 7 lines to the cursors - when moving vertical
set hidden " current buffer can be put into background
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
" set relativenumber " show relative line numbers

set autoindent " automatically set indent of new line
set smartindent

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

" let ayucolor="light"  " for light version of theme
" let ayucolor="mirage" " for mirage version of theme
" let ayucolor="dark"   " for dark version of theme
" colorscheme ayu

" colorscheme srcery
" let g:solarized_visibility="low"
" let g:solarized_termtrans=1
" colorscheme solarized8_dark_high
" colorscheme solarized8_dark

" colorscheme molokai
" colorscheme PaperColor

set foldmethod=manual " solve autocomplete slow problem

" no preview window
set completeopt-=preview

"set columns=100
"set lines=70

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
"set nobackup
"set nowritebackup
"set noswapfile
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
"}}}
