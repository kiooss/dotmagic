return {
  "jose-elias-alvarez/typescript.nvim",
  "folke/twilight.nvim",

  { "editorconfig/editorconfig-vim", event = "VeryLazy" },
  { "AndrewRadev/switch.vim", keys = { "gs" } },
  { "rhysd/committia.vim", lazy = false },

  {
    "folke/styler.nvim",
    event = "VeryLazy",
    config = function()
      require("styler").setup({
        themes = {
          markdown = { colorscheme = "tokyonight-storm" },
          help = { colorscheme = "oxocarbon", background = "dark" },
          noice = { colorscheme = "gruvbox", background = "dark" },
        },
      })
    end,
  },

  {
    "folke/drop.nvim",
    event = "VimEnter",
    enabled = true,
    config = function()
      math.randomseed(os.time())
      local theme = ({ "stars", "snow", "xmas" })[math.random(1, 3)]
      require("drop").setup({ theme = theme })
    end,
  },

  {
    "smjonas/inc-rename.nvim",
    cmd = "IncRename",
    config = true,
  },

  {
    "simrat39/symbols-outline.nvim",
    keys = { { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
    config = true,
  },

  {
    "ThePrimeagen/refactoring.nvim",
    keys = {
      {
        "<leader>r",
        function()
          require("refactoring").select_refactor()
        end,
        mode = "v",
        noremap = true,
        silent = true,
        expr = false,
      },
    },
    config = {},
  },

  {
    "ruanyl/vim-gh-line",
    keys = { "<leader>gm" },
    config = function()
      vim.g.gh_trace = 1
      vim.g.gh_open_command = "echo "
      vim.g.gh_use_canonical = 0
      vim.g.gh_line_blame_map = "<leader>gm"
    end,
  },

  {
    "danymat/neogen",
    config = function()
      require("neogen").setup({ snippet_engine = "luasnip" })
    end,
  },

  -- Theme: icons
  {
    "nvim-tree/nvim-web-devicons",
    config = function()
      require("nvim-web-devicons").setup({ default = true })
    end,
  },

  {
    "dstein64/vim-startuptime",
    cmd = "StartupTime",
    config = function()
      vim.g.startuptime_tries = 10
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "BufReadPre",
    config = function()
      require("treesitter-context").setup()
    end,
  },

  {
    "andymass/vim-matchup",
    event = "BufReadPost",
    enabled = false,
    config = function()
      vim.g.matchup_matchparen_offscreen = { method = "status_manual" }
    end,
  },

  {
    "lambdalisue/suda.vim",
    cmd = { "SudaWrite", "SudaRead" },
  },

  {
    "pechorin/any-jump.vim",
    cmd = { "AnyJump", "AnyJumpVisual" },
  },

  {
    "Wansmer/treesj",
    keys = {
      { "J", "<cmd>TSJToggle<cr>" },
    },
    config = { use_default_keymaps = false },
  },

  { "mhinz/vim-sayonara", cmd = { "Sayonara" } },

  {
    "vimwiki/vimwiki",
    cmd = "VimwikiIndex",
    keys = { "<leader>W" },
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
}
