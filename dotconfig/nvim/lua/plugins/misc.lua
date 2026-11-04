return {
  { "justinsgithub/wezterm-types", lazy = true },
  {
    "folke/lazydev.nvim",
    -- ft = "lua",
    opts = {
      library = {
        wezterm = "wezterm-types",
      },
      -- enabled = true,
    },
  },
  -- { "editorconfig/editorconfig-vim", event = "VeryLazy" },
  { "rhysd/committia.vim", lazy = false },

  {
    "andymass/vim-matchup",
    event = "BufReadPost",
    config = function()
      vim.g.matchup_matchparen_offscreen = { method = "status_manual" }
    end,
  },

  {
    "lambdalisue/suda.vim",
    cmd = { "SudaWrite", "SudaRead" },
  },

  {
    "nvim-mini/mini.splitjoin",
    opts = { mappings = { toggle = "J" } },
    keys = {
      { "J", desc = "Split/Join" },
    },
  },

  {
    "vimwiki/vimwiki",
    cmd = "VimwikiIndex",
    keys = { { "<leader>W", "<cmd>VimwikiIndex<CR>", desc = "VimWiki" } },
    init = function()
      vim.g.vimwiki_global_ext = 0
      vim.g.vimwiki_list = {
        { path = "~/vimwiki/", syntax = "markdown", ext = ".md" },
      }
      vim.g.vimwiki_conceallevel = 0
      vim.g.vimwiki_use_calendar = 1
      vim.g.vimwiki_hl_headers = 1
      vim.g.vimwiki_hl_cb_checked = 1
      vim.g.vimwiki_autowriteall = 0
      vim.g.vimwiki_map_prefix = "<F12>"
      vim.g.vimwiki_table_mappings = 0
    end,
  },

  {
    "tpope/vim-bundler",
    lazy = false,
  },

  {
    "mg979/vim-visual-multi",
    lazy = false,
  },

  -- {
  --   "tpope/vim-rails",
  --   lazy = false,
  -- },
  {
    "fladson/vim-kitty",
    lazy = false,
  },

  {
    "mityu/vim-applescript",
    lazy = false,
  },

  {
    "fei6409/log-highlight.nvim",
    event = "BufRead *.log",
    opts = {},
  },
}
