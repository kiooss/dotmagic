return {
  -- file explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    cmd = "Neotree",
    enabled = false,
    keys = {
      {
        "<leader>ft",
        function()
          require("neo-tree.command").execute({ toggle = true, dir = require("lazyvim.util").get_root() })
        end,
        desc = "NeoTree (root dir)",
      },
      { "<leader>fT", "<cmd>Neotree toggle<CR>", desc = "NeoTree (cwd)" },
    },
    init = function()
      vim.g.neo_tree_remove_legacy_commands = 1
    end,
    opts = {
      filesystem = {
        follow_current_file = true,
        hijack_netrw_behavior = "open_current",
      },
    },
  },

  {
    "nvim-tree/nvim-tree.lua",
    cmd = "NvimTreeFindFileToggle",
    keys = {
      { "<c-p>", "<cmd>NvimTreeFindFileToggle<CR>", desc = "NvimTreeFindFileToggle" },
    },
    opts = {
      -- disables netrw completely
      disable_netrw = true,
      hijack_netrw = true,
      diagnostics = {
        enable = true,
        show_on_dirs = true,
        icons = {
          hint = "",
          info = "",
          warning = "",
          error = "",
        },
      },
      -- hijack the cursor in the tree to put it at the start of the filename
      hijack_cursor = true,
      hijack_directories = {
        enable = true,
        auto_open = true,
      },
      update_cwd = true,
      update_focused_file = {
        enable = true,
      },
      git = {
        enable = true,
        ignore = true,
        timeout = 500,
      },
      view = {
        mappings = {
          list = {
            { key = "<tab>", cb = ":wincmd w<CR>" },
            { key = "l", cb = ":lua require'nvim-tree'.on_keypress('edit')<CR>" },
            { key = "s", cb = ":lua require'nvim-tree'.on_keypress('vsplit')<CR>" },
            { key = "i", cb = ":lua require'nvim-tree'.on_keypress('split')<CR>" },
          },
        },
      },
      actions = {
        open_file = {
          resize_window = true,
        },
      },
      renderer = {
        highlight_git = true,
        highlight_opened_files = "all",
      },
    },
    init = function()
      vim.g.nvim_tree_auto_ignore_ft = { "dashboard", "startify" }
      if vim.fn.argc() == 1 then
        local stat = vim.loop.fs_stat(vim.fn.argv(0))
        if stat and stat.type == "directory" then
          require("nvim-tree")
        end
      end
    end,
  },

  -- which-key
  -- {
  --   "folke/which-key.nvim",
  --   opts = {
  --     plugins = { spelling = true },
  --     key_labels = { ["<leader>"] = "SPC" },
  --   },
  --   config = function(_, opts)
  --     local wk = require("which-key")
  --     wk.setup(opts)
  --     -- wk.register({
  --     --   mode = { "n", "v" },
  --     --   ["g"] = { name = "+goto" },
  --     --   ["]"] = { name = "+next" },
  --     --   ["["] = { name = "+prev" },
  --     --   ["<leader>b"] = { name = "+buffer" },
  --     --   ["<leader>c"] = { name = "+code" },
  --     --   ["<leader>f"] = { name = "+file" },
  --     --   ["<leader>g"] = { name = "+git" },
  --     --   ["<leader>h"] = { name = "+help" },
  --     --   ["<leader>n"] = { name = "+noice" },
  --     --   ["<leader>o"] = { name = "+open" },
  --     --   ["<leader>q"] = { name = "+quit/session" },
  --     --   ["<leader>s"] = { name = "+search" },
  --     --   ["<leader>t"] = { name = "+toggle" },
  --     --   ["<leader>x"] = { name = "+diagnostics/quickfix" },
  --     --   ["<leader><tab>"] = { name = "+tabs" },
  --     -- })
  --   end,
  -- },

  -- additional text objects
  { "wellle/targets.vim", event = "VeryLazy" },
  { "kana/vim-textobj-user", lazy = false, priority = 99 },
  { "kana/vim-textobj-entire", event = "VeryLazy" },
  { "kana/vim-textobj-function", event = "VeryLazy" },
  { "rhysd/vim-textobj-anyblock", event = "VeryLazy" },
  { "nelstrom/vim-textobj-rubyblock", event = "VeryLazy" },
  { "thalesmello/vim-textobj-methodcall", event = "VeryLazy" },

  { "tjdevries/cyclist.vim", lazy = false },
}
