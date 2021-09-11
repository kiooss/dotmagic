local stylua = function()
  return {
    exe = "stylua",
    args = { "--config-path", "~/.config/nvim/.stylua", "-" },
    stdin = true,
  }
end

local luafmt = function()
  return {
    exe = "luafmt",
    args = { "--indent-count", 2, "--stdin" },
    stdin = true,
  }
end

require("formatter").setup({
  filetype = {
    lua = { stylua },
  },
})

-- vim.api.nvim_set_keymap("n", "<leader>e", [[<Cmd>FormatWrite<CR>]], {noremap = true})
