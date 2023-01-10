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
    config = function()
      vim.g.nvim_tree_auto_ignore_ft = { "dashboard", "startify" }

      require("nvim-tree").setup({
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
      })
    end,
  },

  -- additional text objects
  { "wellle/targets.vim", lazy = false },
  { "kana/vim-textobj-user", lazy = false, priority = 99 },
  { "kana/vim-textobj-entire", lazy = false },
  { "kana/vim-textobj-function", lazy = false },
  { "rhysd/vim-textobj-anyblock", lazy = false },
  { "nelstrom/vim-textobj-rubyblock", lazy = false },
  { "thalesmello/vim-textobj-methodcall", lazy = false },

  { "tjdevries/cyclist.vim", lazy = false },
}
