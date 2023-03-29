-- =============================================================================
--  init.lua --- Lua Config Entry file for neovim
-- =============================================================================
if vim.loader then
  vim.loader.enable()
  vim.schedule(function()
    vim.notify("nvim cache is enabled")
  end)
end

local debug = require("util.debug")

if vim.env.VIMCONFIG then
  return debug.switch(vim.env.VIMCONFIG)
end

require("config.lazy")({
  debug = false,
  defaults = {
    lazy = true,
  },
  performance = {
    cache = {
      enabled = true,
    },
  },
})

vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    require("util").version()
  end,
})
