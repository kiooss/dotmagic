Plug 'Yggdroot/indentLine'
Plug 'airblade/vim-gitgutter'
Plug 'alvan/vim-closetag'
Plug 'editorconfig/editorconfig-vim'
Plug 'gregsexton/MatchTag'
Plug 'kiooss/vim-zenkaku-space'
Plug 'mhinz/vim-startify'
" Plug 'glepnir/dashboard-nvim'
Plug 'ntpeters/vim-better-whitespace'
Plug 'pbrisbin/vim-mkdir'
Plug 'ryanoasis/vim-devicons'
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-endwise'
" Plug 'vim-airline/vim-airline' | Plug 'vim-airline/vim-airline-themes'

if has('nvim-0.5')
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'p00f/nvim-ts-rainbow'
Plug 'kyazdani42/nvim-web-devicons'  " for file icons
" Plug 'yamatsum/nvim-nonicons'
Plug 'kyazdani42/nvim-tree.lua'
Plug 'akinsho/bufferline.nvim'
Plug 'glepnir/galaxyline.nvim' , {'branch': 'main'}

" Plug 'nvim-lua/plenary.nvim'
" Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'folke/todo-comments.nvim'

" Plug 'neovim/nvim-lspconfig'

" Plug 'folke/trouble.nvim'


Plug 'mhartington/formatter.nvim' ", { 'as': 'formatter' }

endif
