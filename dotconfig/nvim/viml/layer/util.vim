Plug 'AndrewRadev/splitjoin.vim'
Plug 'AndrewRadev/switch.vim'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'chrisbra/vim-zsh'
Plug 'christianrondeau/vim-base64'
Plug 'dense-analysis/ale'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-peekaboo'
Plug 'justinmk/vim-dirvish'
Plug 'justinmk/vim-sneak'
Plug 'kkoomen/vim-doge'
Plug 'lambdalisue/suda.vim'
Plug 'liuchengxu/vim-which-key'
Plug 'liuchengxu/vista.vim'
Plug 'mbbill/undotree'
Plug 'pechorin/any-jump.vim'
Plug 'prettier/vim-prettier'
Plug 'rhysd/committia.vim'
Plug 'rhysd/vim-grammarous'
Plug 'stephpy/vim-php-cs-fixer'
Plug 'sunaku/vim-dasht'
Plug 'tommcdo/vim-exchange'
Plug 'tpope/vim-dispatch'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-unimpaired'

Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'algotech/ultisnips-php'
Plug 'epilande/vim-react-snippets'
Plug 'mattn/vim-sqlfmt'

if !has('mac')
Plug 'wincent/vim-clipper'
endif

if has('mac')
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }
endif
