filetype off

" vim-pathogen way
" let g:pathogen_disabled = ['emmet-vim', 'taglist', 'promptline', 'vim-gitgutter']
" call pathogen#infect()

" first time run
" curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
"    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

call plug#begin('~/.vim/plugged')

" completion for neovim
function! DoRemote(arg)
  UpdateRemotePlugins
endfunction

Plug 'Shougo/vimproc', { 'do': 'make' }

if has('nvim')
    Plug 'Shougo/deoplete.nvim', { 'do': function('DoRemote') }
    Plug 'Shougo/denite.nvim', { 'do': function('DoRemote') }
else
    Plug 'Shougo/neocomplete.vim'
    Plug 'Shougo/denite.nvim'
end

Plug 'nixprime/cpsm'

Plug 'ryanoasis/vim-devicons'
Plug 'easymotion/vim-easymotion'

" colorschemes
" Plug 'tomasr/molokai'
Plug 'morhetz/gruvbox'
Plug 'atelierbram/vim-colors_atelier-schemes'
Plug 'rhysd/vim-color-spring-night'
" Plug 'vim-scripts/summerfruit256.vim'
" Plug 'nightsense/seabird'
" Plug 'sickill/vim-monokai'
" Plug 'altercation/vim-colors-solarized'
" Plug 'romainl/flattened'
Plug 'lifepillar/vim-solarized8'
" Plug 'tpope/vim-vividchalk'
" Plug 'roosta/srcery'
" Plug 'dracula/vim'
" Plug 'flazz/vim-colorschemes'
" Plug 'chriskempson/base16-vim'
" Plug 'NLKNguyen/papercolor-theme', { 'commit': '867b051d3ad76953d422836445e9f6ce2e95d76c' }

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'scrooloose/nerdtree'
Plug 'editorconfig/editorconfig-vim'
Plug 'pbrisbin/vim-mkdir'
Plug 'tomtom/tcomment_vim'
Plug 'wellle/targets.vim'

Plug 'benmills/vimux'
Plug 'wellle/tmux-complete.vim'
" Plug 'christoomey/vim-tmux-navigator'
Plug 'tmux-plugins/vim-tmux'
" Plug 'ctrlpvim/ctrlp.vim'
Plug 'terryma/vim-multiple-cursors'
Plug 'vim-scripts/gtags.vim'
Plug 'chrisbra/csv.vim'
" Plug 'mattn/emmet-vim', { 'for': 'html' }
Plug 'gregsexton/MatchTag'
if executable('ctags')
    " Plug 'vim-scripts/taglist.vim'
    Plug 'majutsushi/tagbar'
    Plug 'ludovicchabant/vim-gutentags'
end
"Plug 'edkolev/promptline.vim'
Plug 'airblade/vim-gitgutter'
Plug 'vim-scripts/sudo.vim'
Plug 'vim-scripts/CmdlineComplete'
"Plug 'astashov/vim-ruby-debugger'
Plug 'godlygeek/tabular'
Plug 'pangloss/vim-javascript'
"Plug 'tpope/vim-cucumber'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-git'
Plug 'tpope/vim-haml'
Plug 'tpope/vim-markdown'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
"Plug 'vim-scripts/Gist.vim'
Plug 'vim-scripts/IndexedSearch'
Plug 'vim-scripts/jQuery'
Plug 'kana/vim-textobj-user'
Plug 'rhysd/vim-textobj-anyblock'
Plug 'nelstrom/vim-textobj-rubyblock'
" Plug 'jgdavey/vim-blockle'
Plug 'sickill/vim-pasta'
Plug 'tomtom/tlib_vim'
Plug 'MarcWeber/vim-addon-mw-utils'
" Plug 'garbas/vim-snipmate'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'algotech/ultisnips-php'

Plug 'evidens/vim-twig'
Plug 'ervandew/supertab'
" Plug 'mileszs/ack.vim'
Plug 'kchmck/vim-coffee-script'
Plug 'ntpeters/vim-better-whitespace'
" Plug 'nathanaelkane/vim-indent-guides' " use indentLine instead.
Plug 'Yggdroot/indentLine'
" Plug 'Raimondi/delimitMate'
" Plug 'vim-scripts/gitignore'
Plug 'jiangmiao/auto-pairs'
Plug 'thinca/vim-quickrun'
Plug 'luochen1990/rainbow'
" Plug 'gcmt/wildfire.vim'

" asynchonously (requires Vim 8).
if has('nvim') || has('timers') && exists('*job_start') && exists('*ch_close_in')
    Plug 'w0rp/ale'
    com! ALECheckNow call ale#Queue(0)
else
    Plug 'vim-syntastic/syntastic'
endif

" Plugins for php
Plug 'StanAngeloff/php.vim', { 'for': 'php' }
Plug 'shawncplus/phpcomplete.vim', { 'for': 'php' }
Plug 'stephpy/vim-php-cs-fixer', { 'for': 'php' }
Plug 'arnaud-lb/vim-php-namespace', { 'for': 'php' }
Plug 'qbbr/vim-symfony', { 'for': 'php' }
Plug 'docteurklein/php-getter-setter.vim', { 'for': 'php' }
Plug 'tobyS/vmustache', { 'for': 'php' }
Plug 'tobyS/pdv', { 'for': 'php' }

" Plugins for ruby/rails
Plug 'vim-ruby/vim-ruby', { 'for': 'ruby' }
Plug 'ecomba/vim-ruby-refactoring', { 'for': 'ruby' }
Plug 'tsaleh/vim-shoulda', { 'for': 'ruby' }
Plug 'tpope/vim-rails', { 'for': 'ruby' }

" Plugins for css
Plug 'hail2u/vim-css3-syntax', { 'for': 'css' }
Plug 'cakebaker/scss-syntax.vim', { 'for': 'scss' }
Plug 'groenewege/vim-less', { 'for': 'less' }

call plug#end()
filetype plugin indent on
