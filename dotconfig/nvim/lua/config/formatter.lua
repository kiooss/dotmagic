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

local shfmt = function()
  return {
    exe = "shfmt",
    args = { "-i", 2 },
    stdin = true,
  }
end

require("formatter").setup({
  filetype = {
    lua = { stylua },
    sh = { shfmt }
  },
})

-- vim.api.nvim_set_keymap("n", "<leader>e", [[<Cmd>FormatWrite<CR>]], {noremap = true})
