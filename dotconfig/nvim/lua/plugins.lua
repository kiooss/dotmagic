local packer = require('util.packer')
local global = require('core.global')

local config = {
  max_jobs = global.is_mac and 60 or nil,
  profile = {
    enable = true,
    threshold = 0, -- the amount in ms that a plugins load time must be over for it to be included in the profile
  },
  display = {
    -- open_fn = function()
    --   return require('packer.util').float({ border = 'single' })
    -- end,
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

  use({
    'neoclide/coc.nvim',
    disable = true,
    branch = 'release',
    config = function()
      vim.cmd('source ~/.config/nvim/viml/plugins.config/coc.nvim.vim')
    end,
  })

  -- util
  use({ 'nvim-lua/plenary.nvim', module = 'plenary' })
  use({ 'nvim-lua/popup.nvim', module = 'popup' })

  -- LSP related plugins start
  use({
    'neovim/nvim-lspconfig',
    opt = true,
    event = { 'BufReadPre', 'InsertEnter' },
    wants = {
      'nvim-lsp-ts-utils',
      'null-ls.nvim',
      'lua-dev.nvim',
      'schemastore.nvim',
      'nvim-lsp-installer',
    },
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
  -- LSP related plugins end

  -- auto completion
  use({
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    config = function()
      require('config.nvim-cmp')
    end,
    wants = {
      'lspkind-nvim',
    },
    requires = {
      'onsails/lspkind-nvim',
      'hrsh7th/cmp-nvim-lsp',
      { 'hrsh7th/cmp-buffer', after = 'nvim-cmp' },
      { 'hrsh7th/cmp-vsnip', after = 'nvim-cmp' },
      { 'hrsh7th/cmp-path', after = 'nvim-cmp' },
      { 'hrsh7th/cmp-nvim-lua', after = 'nvim-cmp' },
      { 'hrsh7th/cmp-cmdline', after = 'nvim-cmp' },
      { 'octaltree/cmp-look', after = 'nvim-cmp' },
      {
        'windwp/nvim-autopairs',
        after = 'nvim-cmp',
        config = function()
          require('config.autopairs')
        end,
      },
      { 'hrsh7th/vim-vsnip', after = 'nvim-cmp' },
      { 'hrsh7th/vim-vsnip-integ', after = 'nvim-cmp' },
      { 'rafamadriz/friendly-snippets', after = 'vim-vsnip' },
    },
  })

  use({
    'abecodes/tabout.nvim',
    config = function()
      require('config.tabout')
    end,
    wants = { 'nvim-treesitter' }, -- or require if not used so far
    after = { 'nvim-cmp' }, -- if a completion plugin is using tabs load it before
  })

  -- comment plugin
  use({
    'b3nj5m1n/kommentary',
    opt = true,
    wants = 'nvim-ts-context-commentstring',
    keys = { 'gc', '<C-_>' },
    config = function()
      require('config.comments')
    end,
    requires = 'JoosepAlviste/nvim-ts-context-commentstring',
  })

  -- better syntax parser
  use({
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    opt = true,
    event = 'BufRead',
    requires = {
      { 'nvim-treesitter/playground', cmd = 'TSHighlightCapturesUnderCursor' },
      'nvim-treesitter/nvim-treesitter-textobjects',
      'p00f/nvim-ts-rainbow',
      'RRethy/nvim-treesitter-textsubjects',
    },
    config = [[require('config.treesitter')]],
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

  use({
    'rose-pine/neovim',
    config = function()
      require('config.theme')
    end,
  })

  use({
    'folke/tokyonight.nvim',
    config = function()
      require('config.theme')
    end,
  })

  use({
    'sainnhe/everforest',
    config = function()
      require('config.theme')
    end,
  })

  use({
    'ray-x/aurora',
    config = function()
      require('config.theme')
    end,
  })

  use({
    'sainnhe/sonokai',
    config = function()
      require('config.theme')
    end,
  })

  use({
    'bluz71/vim-nightfly-guicolors',
    config = function()
      require('config.theme')
    end,
  })

  -- Theme: icons
  use({
    'kyazdani42/nvim-web-devicons',
    module = 'nvim-web-devicons',
    config = function()
      require('nvim-web-devicons').setup({ default = true })
    end,
  })

  -- Dashboard
  use({ 'glepnir/dashboard-nvim', config = [[require('config.dashboard')]] })

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
    opt = true,
    config = function()
      require('config.telescope')
    end,
    cmd = { 'Telescope' },
    module = 'telescope',
    wants = {
      'plenary.nvim',
      'popup.nvim',
      'telescope-frecency.nvim',
      -- 'telescope-fzy-native.nvim',
      'telescope-fzf-native.nvim',
      'telescope-project.nvim',
      'trouble.nvim',
      'telescope-symbols.nvim',
      'telescope-cheat.nvim',
    },
    requires = {
      'nvim-lua/popup.nvim',
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-project.nvim',
      'nvim-telescope/telescope-symbols.nvim',
      -- 'nvim-telescope/telescope-fzy-native.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
      { 'nvim-telescope/telescope-frecency.nvim', requires = 'tami5/sqlite.lua' },
      { 'nvim-telescope/telescope-cheat.nvim', requires = 'tami5/sqlite.lua' },
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
    config = function()
      require('config.bufferline')
    end,
  })

  -- Terminal
  -- use(
  --   {
  --     "akinsho/nvim-toggleterm.lua",
  --     keys = "<M-`>",
  --     config = function()
  --       require("config.terminal")
  --     end
  --   }
  -- )

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

  -- use(
  --   {
  --     "phaazon/hop.nvim",
  --     keys = {"gh"},
  --     cmd = {"HopWord", "HopChar1"},
  --     config = function()
  --       require("util").nmap("gh", "<cmd>HopWord<CR>")
  --       -- require("util").nmap("s", "<cmd>HopChar1<CR>")
  --       -- you can configure Hop the way you like here; see :h hop-config
  --       require("hop").setup({})
  --     end
  --   }
  -- )

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

  -- use(
  --   {
  --     "folke/persistence.nvim",
  --     event = "BufReadPre",
  --     module = "persistence",
  --     config = function()
  --       require("persistence").setup()
  --     end
  --   }
  -- )

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
  -- use("nanotee/luv-vimdocs")
  use({
    'andymass/vim-matchup',
    event = 'CursorMoved',
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

  -- if global.is_linux then
  --   use({
  --     'wincent/vim-clipper',
  --     setup = function()
  --       vim.g.ClipperMap = 0
  --       vim.g.ClipperAddress = '~/.clipper.sock'
  --       vim.g.ClipperPort = 0
  --     end,
  --   })
  -- end

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
    config = function()
      require('config.toggleterm')
    end,
  })
end

return packer.setup(config, plugins)
