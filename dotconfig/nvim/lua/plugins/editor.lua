local handler = function(virtText, lnum, endLnum, width, truncate)
  local newVirtText = {}
  local suffix = ("  %d "):format(endLnum - lnum)
  local sufWidth = vim.fn.strdisplaywidth(suffix)
  local targetWidth = width - sufWidth
  local curWidth = 0
  for _, chunk in ipairs(virtText) do
    local chunkText = chunk[1]
    local chunkWidth = vim.fn.strdisplaywidth(chunkText)
    if targetWidth > curWidth + chunkWidth then
      table.insert(newVirtText, chunk)
    else
      chunkText = truncate(chunkText, targetWidth - curWidth)
      local hlGroup = chunk[2]
      table.insert(newVirtText, { chunkText, hlGroup })
      chunkWidth = vim.fn.strdisplaywidth(chunkText)
      -- str width returned from truncate() may less than 2nd argument, need padding
      if curWidth + chunkWidth < targetWidth then
        suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
      end
      break
    end
    curWidth = curWidth + chunkWidth
  end
  table.insert(newVirtText, { suffix, "MoreMsg" })
  return newVirtText
end

return {
  -- file explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    enabled = false,
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

  -- git signs
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add = { text = "▋" },
        change = { text = "▋" },
        delete = { text = "契" },
        topdelete = { text = "契" },
        changedelete = { text = "" },
        untracked = { text = "▋" },
      },
      numhl = true,
      linehl = true,
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

  -- add nvim-ufo
  {
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
    event = "BufReadPost",
    opts = {
      fold_virt_text_handler = handler,
    },
    init = function()
      -- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
      vim.keymap.set("n", "zR", function()
        require("ufo").openAllFolds()
      end)
      vim.keymap.set("n", "zM", function()
        require("ufo").closeAllFolds()
      end)
      vim.keymap.set("n", "zr", function()
        require("ufo").openFoldsExceptKinds()
      end)
      vim.keymap.set("n", "zm", function()
        require("ufo").closeFoldsWith()
      end)
    end,
  },
}
