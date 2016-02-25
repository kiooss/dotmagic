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

Plug 'scrooloose/nerdtree'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'vim-scripts/gtags.vim'
Plug 'docteurklein/php-getter-setter.vim'
Plug 'chrisbra/csv.vim'
Plug 'mattn/emmet-vim'
Plug 'gregsexton/MatchTag'
Plug 'vim-scripts/taglist.vim'
Plug 'pbrisbin/vim-mkdir'
Plug 'edkolev/promptline.vim'
Plug 'airblade/vim-gitgutter'
Plug 'shawncplus/phpcomplete.vim'
Plug 'vim-scripts/sudo.vim'
Plug 'astashov/vim-ruby-debugger'
Plug 'godlygeek/tabular'
Plug 'pangloss/vim-javascript'
Plug 'timcharper/textile.vim'
Plug 'tomtom/tcomment_vim'
Plug 'tpope/vim-cucumber'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-git'
Plug 'tpope/vim-haml'
Plug 'tpope/vim-markdown'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-vividchalk'
Plug 'tsaleh/vim-shoulda'
Plug 'vim-ruby/vim-ruby'
Plug 'vim-scripts/Gist.vim'
Plug 'vim-scripts/IndexedSearch'
Plug 'vim-scripts/jQuery'
Plug 'kana/vim-textobj-user'
Plug 'nelstrom/vim-textobj-rubyblock'
Plug 'jgdavey/vim-blockle'
Plug 'Shougo/neocomplcache'
Plug 'sickill/vim-pasta'
Plug 'ecomba/vim-ruby-refactoring'
Plug 'tomtom/tlib_vim'
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'garbas/vim-snipmate'
Plug 'honza/vim-snippets'
Plug 'evidens/vim-twig'
Plug 'ervandew/supertab'
Plug 'arnaud-lb/vim-php-namespace'
Plug 'qbbr/vim-symfony'
Plug 'editorconfig/editorconfig-vim'
Plug 'mileszs/ack.vim'
Plug 'kchmck/vim-coffee-script'
Plug 'ntpeters/vim-better-whitespace'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'bling/vim-airline'
Plug 'Raimondi/delimitMate'

call plug#end()
filetype plugin indent on
