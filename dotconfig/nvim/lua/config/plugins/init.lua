return {
  'b0o/SchemaStore.nvim',
  'jose-elias-alvarez/typescript.nvim',
  'folke/neodev.nvim',
  'MunifTanjim/nui.nvim',
  'williamboman/mason-lspconfig.nvim',
  'nvim-lua/plenary.nvim',
  'windwp/nvim-spectre',
  'folke/twilight.nvim',
  'folke/which-key.nvim',

  { 'editorconfig/editorconfig-vim', event = 'VeryLazy' },
  { 'AndrewRadev/switch.vim', keys = { 'gs' } },
  { 'rhysd/committia.vim', lazy = false },

  -- additional text objects
  { 'wellle/targets.vim', lazy = false },
  { 'kana/vim-textobj-user', lazy = false, priority = 99 },
  { 'kana/vim-textobj-entire', lazy = false },
  { 'kana/vim-textobj-function', lazy = false },
  { 'rhysd/vim-textobj-anyblock', lazy = false },
  { 'nelstrom/vim-textobj-rubyblock', lazy = false },
  { 'thalesmello/vim-textobj-methodcall', lazy = false },

  { 'folke/neoconf.nvim', cmd = 'Neoconf' },

  { 'shaunsingh/oxocarbon.nvim', lazy = false, enabled = true },

  { 'ellisonleao/gruvbox.nvim', lazy = false },

  { 'tjdevries/cyclist.vim', lazy = false },

  {
    'folke/trouble.nvim',
    cmd = { 'TroubleToggle', 'Trouble' },
    config = function()
      require('trouble').setup({
        auto_open = false,
        use_diagnostic_signs = true, -- en
      })
    end,
  },

  {
    'folke/styler.nvim',
    event = 'VeryLazy',
    config = function()
      require('styler').setup({
        themes = {
          markdown = { colorscheme = 'tokyonight-storm' },
          -- help = { colorscheme = 'oxocarbon', background = 'dark' },
          -- noice = { colorscheme = "gruvbox", background = "dark" },
        },
      })
    end,
  },

  {
    'folke/drop.nvim',
    event = 'VimEnter',
    enabled = true,
    config = function()
      math.randomseed(os.time())
      local theme = ({ 'stars', 'snow', 'xmas' })[math.random(1, 3)]
      require('drop').setup({ theme = theme })
    end,
  },

  -- {
  --   'nathom/filetype.nvim',
  --   config = function()
  --     require('config.plugins.filetype')
  --   end,
  -- },

  {
    'ruanyl/vim-gh-line',
    keys = { '<leader>gm' },
    config = function()
      vim.g.gh_trace = 1
      vim.g.gh_open_command = 'echo '
      vim.g.gh_use_canonical = 0
      vim.g.gh_line_blame_map = '<leader>gm'
    end,
  },

  {
    'danymat/neogen',
    config = function()
      require('neogen').setup({ snippet_engine = 'luasnip' })
    end,
  },

  -- Theme: icons
  {
    'nvim-tree/nvim-web-devicons',
    config = function()
      require('nvim-web-devicons').setup({ default = true })
    end,
  },

  {
    'smjonas/inc-rename.nvim',
    cmd = 'IncRename',
    config = function()
      require('inc_rename').setup()
    end,
  },

  {
    'dstein64/vim-startuptime',
    cmd = 'StartupTime',
    config = function()
      vim.g.startuptime_tries = 10
    end,
  },

  {
    'nvim-treesitter/nvim-treesitter-context',
    event = 'BufReadPre',
    config = function()
      require('treesitter-context').setup()
    end,
  },

  {
    'SmiteshP/nvim-navic',
    config = function()
      vim.g.navic_silence = true
      require('nvim-navic').setup({ separator = ' ', highlight = true, depth_limit = 5 })
    end,
  },

  {
    'andymass/vim-matchup',
    event = 'BufReadPost',
    config = function()
      vim.g.matchup_matchparen_offscreen = { method = 'status_manual' }
    end,
  },

  {
    'lambdalisue/suda.vim',
    cmd = { 'SudaWrite', 'SudaRead' },
  },

  {
    'pechorin/any-jump.vim',
    cmd = { 'AnyJump', 'AnyJumpVisual' },
  },

  { 'mhinz/vim-sayonara', cmd = { 'Sayonara' } },

  {
    'vimwiki/vimwiki',
    cmd = 'VimwikiIndex',
    keys = { '<leader>W' },
    init = function()
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
  },
}
