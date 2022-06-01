local packer = require('util.packer')
local global = require('core.global')

local config = {
  max_jobs = global.is_mac and 60 or nil,
  profile = {
    enable = false,
    threshold = 0, -- the amount in ms that a plugins load time must be over for it to be included in the profile
  },
  log = { level = 'trace' }, -- The default print log level. One of: "trace", "debug", "info", "warn", "error", "fatal".
  display = {
    open_fn = function()
      local lines = vim.o.lines
      local height = math.ceil(lines * 0.8 - 10)
      local top = math.ceil((lines - height) * 0.2 - 1)

      return require('packer.util').float({ border = 'rounded', height = height, row = top })
    end,
    working_sym = '🛠', -- The symbol for a plugin being installed/updated
    error_sym = '🧨', -- The symbol for a plugin with an error in installation/updating
    done_sym = '🎉', -- The symbol for a plugin which has completed installation/updating
    removed_sym = '🔥', -- The symbol for an unused plugin which was removed
    moved_sym = '🚀', -- The symbol for a plugin which was moved (e.g. from opt to start)
    header_sym = '━', -- The symbol for the header line in packer's display
  },
  -- list of plugins that should be taken from ~/projects
  -- this is NOT packer functionality!
  local_plugins = {},
}

local function plugins(use)
  -- Packer can manage itself as an optional plugin
  use({ 'wbthomason/packer.nvim', opt = true })
  use({
    'nathom/filetype.nvim',
    config = function()
      require('config.filetype')
    end,
  })

  -- better syntax parser
  use({
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    requires = {
      { 'nvim-treesitter/playground', cmd = 'TSHighlightCapturesUnderCursor' },
      'nvim-treesitter/nvim-treesitter-textobjects',
      'p00f/nvim-ts-rainbow',
      'RRethy/nvim-treesitter-textsubjects',
    },
    config = function()
      require('config.treesitter')
    end,
  })

  use({ 'sheerun/vim-polyglot' })

  -- util
  use({ 'nvim-lua/plenary.nvim', module = 'plenary' })
  use({ 'nvim-lua/popup.nvim', module = 'popup' })

  -- LSP related plugins start
  use({
    'neovim/nvim-lspconfig',
    config = function()
      require('config.lsp')
    end,
    requires = {
      'jose-elias-alvarez/nvim-lsp-ts-utils',
      'jose-elias-alvarez/null-ls.nvim',
      'folke/lua-dev.nvim',
      'b0o/schemastore.nvim',
      'williamboman/nvim-lsp-installer',
    },
  })

  use({
    'RRethy/vim-illuminate',
    event = 'CursorHold',
    module = 'illuminate',
    config = function()
      vim.g.Illuminate_delay = 100
    end,
  })

  use({
    'kosayoda/nvim-lightbulb',
    disable = true,
    config = function()
      require('config.lightbulb')
    end,
  })

  use({
    'simrat39/symbols-outline.nvim',
    cmd = { 'SymbolsOutline' },
  })

  use({
    'liuchengxu/vista.vim',
    after = 'nvim-lspconfig',
    cmd = { 'Vista', 'Vista!!' },
    config = function()
      vim.g.vista_default_executive = 'nvim_lsp'
    end,
  })
  use({
    'j-hui/fidget.nvim',
    config = function()
      require('config.fidget')
    end,
  })
  -- LSP related plugins end

  -- snippets plugin
  use({
    'L3MON4D3/LuaSnip',
    config = function()
      require('config.luasnip')
    end,
    requires = {
      { 'rafamadriz/friendly-snippets' },
      { 'Nash0x7E2/awesome-flutter-snippets' },
    },
  })

  -- auto completion
  use({
    'hrsh7th/nvim-cmp',
    config = function()
      require('config.nvim-cmp')
    end,
    requires = {
      'onsails/lspkind-nvim',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-vsnip',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp-cmdline',
      'dmitmel/cmp-cmdline-history',
      'octaltree/cmp-look',
      'ray-x/cmp-treesitter',
      'andersevenrud/cmp-tmux',
      'saadparwaiz1/cmp_luasnip',
      {
        'windwp/nvim-autopairs',
        config = function()
          require('config.autopairs')
        end,
      },
      -- { 'hrsh7th/vim-vsnip', after = 'nvim-cmp' },
      -- { 'hrsh7th/vim-vsnip-integ', after = 'nvim-cmp' },
    },
  })

  -- comment plugin
  use({
    'numToStr/Comment.nvim',
    opt = true,
    keys = { 'gc', '<C-_>' },
    config = function()
      require('config.comment')
    end,
  })

  -- display colors
  use({
    'norcalli/nvim-colorizer.lua',
    config = function()
      require('config.colorizer')
    end,
  })

  -- Theme: color schemes
  -- use("tjdevries/colorbuddy.vim")
  -- "shaunsingh/nord.nvim",
  -- "shaunsingh/moonlight.nvim",
  -- { "olimorris/onedark.nvim", requires = "rktjmp/lush.nvim" },
  -- "joshdick/onedark.vim",
  -- "wadackel/vim-dogrun",
  -- { "npxbr/gruvbox.nvim", requires = "rktjmp/lush.nvim" },
  -- "bluz71/vim-nightfly-guicolors",
  -- { "marko-cerovac/material.nvim" },
  -- "sainnhe/edge",
  -- { "embark-theme/vim", as = "embark" },
  -- "norcalli/nvim-base16.lua",
  -- "RRethy/nvim-base16",
  -- "novakne/kosmikoa.nvim",
  -- "glepnir/zephyr-nvim",
  -- "ghifarit53/tokyonight-vim"
  -- "sainnhe/sonokai",
  -- "morhetz/gruvbox",
  -- "arcticicestudio/nord-vim",
  -- "drewtempelmeyer/palenight.vim",
  -- "Th3Whit3Wolf/onebuddy",
  -- "christianchiarulli/nvcode-color-schemes.vim",
  -- "Th3Whit3Wolf/one-nvim"
  -- "folke/tokyonight.nvim",
  -- "glepnir/zephyr-nvim",

  use('folke/tokyonight.nvim')
  use('sainnhe/everforest')
  use('ray-x/aurora')
  use('sainnhe/sonokai')
  use('bluz71/vim-nightfly-guicolors')
  use('EdenEast/nightfox.nvim')
  use({ 'rose-pine/neovim', as = 'rose-pine' })
  use({ 'catppuccin/nvim', as = 'catppuccin' })

  -- Theme: icons
  use({
    'kyazdani42/nvim-web-devicons',
    module = 'nvim-web-devicons',
    config = function()
      require('nvim-web-devicons').setup({ default = true })
    end,
  })

  -- Dashboard
  use({
    'glepnir/dashboard-nvim',
    config = function()
      require('config.dashboard')
    end,
  })

  use({
    'norcalli/nvim-terminal.lua',
    ft = 'terminal',
    config = function()
      require('terminal').setup()
    end,
  })

  -- search and replace
  use({
    'windwp/nvim-spectre',
    opt = true,
    module = 'spectre',
    wants = { 'plenary.nvim', 'popup.nvim' },
    requires = { 'nvim-lua/popup.nvim', 'nvim-lua/plenary.nvim' },
  })

  -- file explorer
  use({
    'kyazdani42/nvim-tree.lua',
    config = function()
      require('config.tree')
    end,
  })

  use({
    'mhartington/formatter.nvim',
    cmd = { 'Format', 'FormatWrite' },
    config = function()
      require('config.formatter')
    end,
  })

  -- Fuzzy finder
  use({
    'nvim-telescope/telescope.nvim',
    config = function()
      require('config.telescope')
    end,
    requires = {
      'nvim-lua/popup.nvim',
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-project.nvim',
      'nvim-telescope/telescope-file-browser.nvim',
      'nvim-telescope/telescope-symbols.nvim',
      -- 'nvim-telescope/telescope-fzy-native.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
      { 'nvim-telescope/telescope-frecency.nvim', requires = 'tami5/sqlite.lua' },
    },
  })

  use({
    'sudormrfbin/cheatsheet.nvim',
    -- requires = {
    --   { "nvim-telescope/telescope.nvim" },
    --   { "nvim-lua/popup.nvim" },
    --   { "nvim-lua/plenary.nvim" },
    -- },
    config = function()
      require('cheatsheet').setup({
        bundled_cheatsheets = true,
        bundled_plugin_cheatsheets = true,
        include_only_installed_plugins = true,
      })
    end,
  })

  -- Indent Guides and rainbow brackets
  use({
    'lukas-reineke/indent-blankline.nvim',
    event = 'BufReadPre',
    config = function()
      require('config.indent-blankline')
    end,
  })

  -- Tabline
  use({
    'akinsho/nvim-bufferline.lua',
    event = 'BufReadPre',
    wants = 'nvim-web-devicons',
    branch = 'main',
    config = function()
      require('config.bufferline')
    end,
  })

  -- Smooth Scrolling
  use({
    'karb94/neoscroll.nvim',
    keys = { '<C-u>', '<C-d>', '<C-b>', '<C-f>', '<C-y>', '<C-e>', 'zt', 'zz', 'zb' },
    config = function()
      require('config.scroll')
    end,
  })

  use({
    'edluffy/specs.nvim',
    after = 'neoscroll.nvim',
    config = function()
      require('config.specs')
    end,
  })

  use({
    'kevinhwang91/nvim-hlslens',
    config = function()
      require('config.hlslens')
    end,
  })

  -- use { "Xuyuanp/scrollbar.nvim", config = function() require("config.scrollbar") end }

  -- Git signs
  use({
    'lewis6991/gitsigns.nvim',
    event = 'BufReadPre',
    wants = 'plenary.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('config.gitsigns')
    end,
  })

  use({
    'TimUntersberger/neogit',
    cmd = 'Neogit',
    config = function()
      require('config.neogit')
    end,
  })

  -- Statusline
  use({
    'hoob3rt/lualine.nvim',
    disable = true,
    event = 'VimEnter',
    config = [[require('config.lualine')]],
    wants = 'nvim-web-devicons',
  })

  use({
    'glepnir/galaxyline.nvim',
    config = function()
      require('config.galaxyline')
    end,
    requires = { 'kyazdani42/nvim-web-devicons', opt = true },
  })

  use({
    'SmiteshP/nvim-gps',
    config = function()
      require('config.gps')
    end,
    requires = 'nvim-treesitter/nvim-treesitter',
  })

  -- use({"npxbr/glow.nvim", cmd = "Glow"})

  use({
    'plasticboy/vim-markdown',
    opt = true,
    requires = 'godlygeek/tabular',
    ft = 'markdown',
  })

  use({
    'iamcco/markdown-preview.nvim',
    run = function()
      vim.fn['mkdp#util#install']()
    end,
    ft = 'markdown',
    cmd = { 'MarkdownPreview' },
  })

  -- use { "tjdevries/train.nvim", cmd = { "TrainClear", "TrainTextObj", "TrainUpDown", "TrainWord" } }

  -- use({
  --   "wfxr/minimap.vim",
  --   config = function()
  --     require("config.minimap")
  --   end,
  -- })

  use({
    'phaazon/hop.nvim',
    keys = { 'gh' },
    cmd = { 'HopWord', 'HopChar1' },
    config = function()
      require('config.hop')
    end,
  })

  -- use(
  --   {
  --     "ggandor/lightspeed.nvim",
  --     event = "BufReadPost",
  --     config = function()
  --       require("config.lightspeed")
  --     end
  --   }
  -- )

  use({
    'folke/trouble.nvim',
    event = 'BufReadPre',
    wants = 'nvim-web-devicons',
    cmd = { 'TroubleToggle', 'Trouble' },
    config = function()
      require('trouble').setup({ auto_open = false })
    end,
  })

  use({ 'tweekmonster/startuptime.vim', cmd = 'StartupTime' })

  use({ 'mbbill/undotree', cmd = 'UndotreeToggle' })

  use({
    'folke/todo-comments.nvim',
    cmd = { 'TodoTrouble', 'TodoTelescope' },
    event = 'BufReadPost',
    config = function()
      require('config.todo-comments')
    end,
  })

  use({
    'folke/which-key.nvim',
    event = 'VimEnter',
    config = function()
      require('config.keys')
    end,
  })

  use({
    'sindrets/diffview.nvim',
    cmd = {
      'DiffviewOpen',
      'DiffviewClose',
      'DiffviewToggleFiles',
      'DiffviewFocusFiles',
    },
    config = function()
      require('config.diffview')
    end,
  })

  -- use("DanilaMihailov/vim-tips-wiki")
  use({
    'andymass/vim-matchup',
    event = 'CursorMoved',
    config = function()
      vim.g.matchup_matchparen_offscreen = { method = 'status_manual' }
    end,
  })
  -- use({"camspiers/snap", rocks = {"fzy"}, module = "snap"})

  use({
    'tpope/vim-endwise',
    config = function()
      vim.g.endwise_no_mappings = 1
    end,
  })

  use({ 'mhinz/vim-sayonara', cmd = { 'Sayonara' } })

  use({ 'AndrewRadev/switch.vim' })

  use({ 'kiooss/vim-zenkaku-space' })

  use({
    'jghauser/mkdir.nvim',
    config = function()
      require('mkdir')
    end,
  })

  use({
    'lambdalisue/suda.vim',
    cmd = { 'SudaWrite', 'SudaRead' },
  })

  use({
    'pechorin/any-jump.vim',
    cmd = { 'AnyJump', 'AnyJumpVisual' },
  })

  use({
    'rhysd/committia.vim',
    ft = 'gitcommit',
  })

  use({
    'mattn/vim-sqlfmt',
    ft = 'sql',
  })

  -- align
  use({ 'junegunn/vim-easy-align' })

  -- additional text objects
  use({ 'wellle/targets.vim' })
  use({ 'rhysd/vim-textobj-anyblock' })
  use({ 'kana/vim-textobj-entire' })
  use({ 'kana/vim-textobj-function' })
  use({ 'kana/vim-textobj-user' })
  use({ 'nelstrom/vim-textobj-rubyblock' })
  use({ 'thalesmello/vim-textobj-methodcall' })

  use({ 'tpope/vim-repeat' })
  use({
    'tpope/vim-surround',
    config = function()
      vim.g.surround_no_insert_mappings = 1
    end,
  })

  -- use({
  --   "SirVer/ultisnips",
  --   setup = function()
  --     vim.g.UltiSnipsExpandTrigger = "<c-k>"
  --     vim.g.UltiSnipsJumpForwardTrigger = "<c-k>"
  --     vim.g.UltiSnipsJumpBackwardTrigger = "<c-j>"
  --     vim.g.UltiSnipsEditSplit = "vertical"
  --     vim.g.UltiSnipsSnippetDirectories = { "UltiSnips" }
  --   end,
  -- })
  -- use({ 'honza/vim-snippets' })
  -- use({ 'algotech/ultisnips-php' })
  -- use({ 'epilande/vim-react-snippets' })

  use({ 'famiu/bufdelete.nvim', cmd = 'Bdelete' })
  use({ 'editorconfig/editorconfig-vim' })

  use({
    'vimwiki/vimwiki',
    opt = true,
    cmd = 'VimwikiIndex',
    keys = { '<leader>W' },
    setup = function()
      vim.g.vimwiki_list = {
        { path = '~/vimwiki/', syntax = 'markdown', ext = '.md' },
      }
      vim.g.vimwiki_conceallevel = 0
      vim.g.vimwiki_use_calendar = 1
      vim.g.vimwiki_hl_headers = 1
      vim.g.vimwiki_hl_cb_checked = 1
      vim.g.vimwiki_autowriteall = 0
      vim.g.vimwiki_map_prefix = '<F12>'
      vim.g.vimwiki_table_mappings = 0
    end,
  })

  use({ 'mg979/vim-visual-multi' })

  use({ 'tpope/vim-fugitive' })
  use({ 'tpope/vim-rhubarb' })
  use({
    'ruanyl/vim-gh-line',
    config = function()
      vim.g.gh_trace = 1
      vim.g.gh_open_command = 'echo '
      vim.g.gh_use_canonical = 0
      vim.g.gh_line_blame_map = '<leader>gm'
    end,
  })

  -- notification windows
  use({
    'rcarriga/nvim-notify',
    config = function()
      vim.notify = require('notify')
    end,
  })

  -- copy text to the system clipboard from anywhere
  use({ 'ojroques/vim-oscyank' })

  -- Syntax plugins
  use({ 'lumiliet/vim-twig', ft = 'twig' })

  -- other mixed
  use({ 'ThePrimeagen/vim-be-good', cmd = 'VimBeGood' })

  use({
    'github/copilot.vim',
    config = function()
      require('config.copilot')
    end,
  })

  use({
    'akinsho/toggleterm.nvim',
    branch = 'main',
    config = function()
      require('config.toggleterm')
    end,
  })

  use({ 'tjdevries/cyclist.vim' })

  use({
    'michaelb/sniprun',
    cmd = { 'SnipRun', 'SnipReset' },
    run = 'bash ./install.sh',
    config = function()
      require('config.sniprun')
    end,
  })

  use({
    'AndrewRadev/splitjoin.vim',
    keys = { 'gS', 'gJ' },
  })

  -- flutter
  use({ 'akinsho/flutter-tools.nvim', requires = 'nvim-lua/plenary.nvim' })

  use({
    'stevearc/dressing.nvim',
    config = function()
      require('config.dressing')
    end,
  })

  use({
    'anuvyklack/pretty-fold.nvim',
    requires = 'anuvyklack/nvim-keymap-amend', -- only for preview
    config = function()
      require('config.pretty-fold')
    end,
  })

  use({
    'kkoomen/vim-doge',
    run = function()
      vim.fn['doge#install']()
    end,
    config = function()
      require('config.vim-doge')
    end,
  })

  use({
    'danymat/neogen',
    config = function()
      require('config.neogen')
      require('neogen').setup({})
    end,
    requires = 'nvim-treesitter/nvim-treesitter',
  })
end

return packer.setup(config, plugins)
