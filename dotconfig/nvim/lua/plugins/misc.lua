return {
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
    "Wansmer/treesj",
    keys = {
      { "J", "<cmd>TSJToggle<cr>", desc = "Join Toggle" },
    },
    opts = { use_default_keymaps = false, max_join_length = 150 },
  },

  {
    "mhinz/vim-sayonara",
    enabled = false,
    cmd = { "Sayonara" },
    keys = { { "q", "<cmd>Sayonara<CR>", desc = "Sayonara" } },
  },

  {
    "vimwiki/vimwiki",
    cmd = "VimwikiIndex",
    keys = { { "<leader>W", "<cmd>VimwikiIndex<CR>", desc = "VimWiki" } },
    init = function()
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
}
