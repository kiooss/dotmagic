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

if has('nvim')
    Plug 'Shougo/deoplete.nvim', { 'do': function('DoRemote') }
else
    Plug 'Shougo/neocomplete.vim'
end


" colorschemes
" Plug 'tomasr/molokai'
Plug 'morhetz/gruvbox'
" Plug 'sickill/vim-monokai'
Plug 'altercation/vim-colors-solarized'
Plug 'romainl/flattened'
Plug 'lifepillar/vim-solarized8'
" Plug 'tpope/vim-vividchalk'
Plug 'roosta/srcery'
Plug 'dracula/vim'
" Plug 'flazz/vim-colorschemes'
Plug 'chriskempson/base16-vim'
Plug 'NLKNguyen/papercolor-theme', { 'commit': '867b051d3ad76953d422836445e9f6ce2e95d76c' }

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'scrooloose/nerdtree'
Plug 'editorconfig/editorconfig-vim'
Plug 'pbrisbin/vim-mkdir'
Plug 'tomtom/tcomment_vim'

" Plug 'benmills/vimux'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'terryma/vim-multiple-cursors'
Plug 'vim-scripts/gtags.vim'
Plug 'chrisbra/csv.vim'
" Plug 'mattn/emmet-vim', { 'for': 'html' }
Plug 'gregsexton/MatchTag'
if executable('ctags')
    " Plug 'vim-scripts/taglist.vim'
    Plug 'majutsushi/tagbar'
end
"Plug 'edkolev/promptline.vim'
" Plug 'airblade/vim-gitgutter', { 'commit': '0e490ec' }
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
Plug 'tpope/vim-rails', { 'for': 'ruby' }
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'vim-ruby/vim-ruby', { 'for': 'ruby' }
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
Plug 'nathanaelkane/vim-indent-guides'
" Plug 'Raimondi/delimitMate'
" Plug 'vim-scripts/gitignore'
Plug 'jiangmiao/auto-pairs'
Plug 'thinca/vim-quickrun'
Plug 'luochen1990/rainbow'
Plug 'gcmt/wildfire.vim'

Plug 'StanAngeloff/php.vim', { 'for': 'php' }
Plug 'shawncplus/phpcomplete.vim', { 'for': 'php' }
Plug 'stephpy/vim-php-cs-fixer', { 'for': 'php' }
Plug 'arnaud-lb/vim-php-namespace', { 'for': 'php' }
Plug 'qbbr/vim-symfony', { 'for': 'php' }
Plug 'docteurklein/php-getter-setter.vim', { 'for': 'php' }
Plug 'ecomba/vim-ruby-refactoring', { 'for': 'ruby' }
Plug 'tsaleh/vim-shoulda', { 'for': 'ruby' }
Plug 'groenewege/vim-less', { 'for': 'less' }
Plug 'hail2u/vim-css3-syntax', { 'for': 'css' }
Plug 'cakebaker/scss-syntax.vim', { 'for': 'scss' }

Plug 'ryanoasis/vim-devicons'
Plug 'easymotion/vim-easymotion'
" Plug 'ap/vim-css-color'
" Plug 'kshenoy/vim-signature'

Plug 'Shougo/vimproc', { 'do': 'make' }
" Plug 'Shougo/unite.vim'
" Plug 'm2mdas/phpcomplete-extended', { 'for': 'php' }
" Plug 'm2mdas/phpcomplete-extended-symfony', { 'for': 'php' }


" Plug 'mkusher/padawan.vim'


call plug#end()
filetype plugin indent on
