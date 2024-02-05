return {
  -- file explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    enabled = false,
  },

  -- git signs
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add = { text = "▋" },
        change = { text = "▋" },
        changedelete = { text = "" },
        untracked = { text = "▋" },
      },
      -- numhl = true,
      -- linehl = true,
      current_line_blame = true,
    },
  },

  -- additional text objects
  { "wellle/targets.vim", event = "VeryLazy" },
  { "kana/vim-textobj-user", lazy = false, priority = 99 },
  { "kana/vim-textobj-entire", event = "VeryLazy" },
  { "kana/vim-textobj-function", event = "VeryLazy" },
  { "rhysd/vim-textobj-anyblock", event = "VeryLazy" },
  { "nelstrom/vim-textobj-rubyblock", event = "VeryLazy" },
  { "thalesmello/vim-textobj-methodcall", event = "VeryLazy" },

  { "tjdevries/cyclist.vim", lazy = false },

  -- add folding range to capabilities
  {
    "neovim/nvim-lspconfig",
    opts = {
      capabilities = {
        textDocument = {
          foldingRange = {
            dynamicRegistration = false,
            lineFoldingOnly = true,
          },
        },
      },
    },
  },

  {
    "rasulomaroff/reactive.nvim",
    event = "VeryLazy",
    opts = {
      builtin = {
        cursorline = true,
        cursor = true,
        modemsg = true,
      },
    },
  },
}
