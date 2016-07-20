filetype off

" vim-pathogen way
" let g:pathogen_disabled = ['emmet-vim', 'taglist', 'promptline', 'vim-gitgutter']
" call pathogen#infect()

" first time run
" curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
"    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

call plug#begin('~/.vim/plugged')

" colorschemes
Plug 'tomasr/molokai'
Plug 'morhetz/gruvbox'
Plug 'sickill/vim-monokai'
Plug 'altercation/vim-colors-solarized'
Plug 'lifepillar/vim-solarized8'
Plug 'tpope/vim-vividchalk'
Plug 'roosta/srcery'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'scrooloose/nerdtree'
Plug 'editorconfig/editorconfig-vim'
Plug 'pbrisbin/vim-mkdir'
Plug 'tomtom/tcomment_vim'
Plug 'Shougo/neocomplete.vim'

" Plug 'benmills/vimux'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'terryma/vim-multiple-cursors'
Plug 'vim-scripts/gtags.vim'
Plug 'chrisbra/csv.vim'
Plug 'mattn/emmet-vim'
Plug 'gregsexton/MatchTag'
Plug 'vim-scripts/taglist.vim'
"Plug 'edkolev/promptline.vim'
Plug 'airblade/vim-gitgutter'
Plug 'vim-scripts/sudo.vim'
"Plug 'astashov/vim-ruby-debugger'
Plug 'godlygeek/tabular'
Plug 'pangloss/vim-javascript'
Plug 'timcharper/textile.vim'
"Plug 'tpope/vim-cucumber'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-git'
Plug 'tpope/vim-haml'
Plug 'tpope/vim-markdown'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tsaleh/vim-shoulda'
Plug 'vim-ruby/vim-ruby'
"Plug 'vim-scripts/Gist.vim'
Plug 'vim-scripts/IndexedSearch'
Plug 'vim-scripts/jQuery'
Plug 'kana/vim-textobj-user'
Plug 'nelstrom/vim-textobj-rubyblock'
Plug 'jgdavey/vim-blockle'
Plug 'sickill/vim-pasta'
Plug 'ecomba/vim-ruby-refactoring'
Plug 'tomtom/tlib_vim'
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'garbas/vim-snipmate'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'algotech/ultisnips-php'
Plug 'evidens/vim-twig'
Plug 'ervandew/supertab'
Plug 'mileszs/ack.vim'
Plug 'kchmck/vim-coffee-script'
Plug 'ntpeters/vim-better-whitespace'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'Raimondi/delimitMate'
Plug 'lfilho/cosco.vim'

Plug 'shawncplus/phpcomplete.vim', { 'for': 'php' }
Plug 'StanAngeloff/php.vim', { 'for': 'php' }
Plug 'stephpy/vim-php-cs-fixer', { 'for': 'php' }
Plug 'arnaud-lb/vim-php-namespace', { 'for': 'php' }
Plug 'qbbr/vim-symfony', { 'for': 'php' }
Plug 'docteurklein/php-getter-setter.vim', { 'for': 'php' }

call plug#end()
filetype plugin indent on
