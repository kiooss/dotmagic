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
