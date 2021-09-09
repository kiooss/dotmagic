-- =============================================================================
--  init.lua --- Lua Config Entry file for neovim
--  => Yang Yang
-- =============================================================================

require("util")
require("options")

-- no need to load this immediately, since we have packer_compiled
vim.defer_fn(function()
  require("plugins")
end, 0)

vim.cmd 'source ~/.config/nvim/viml/general.vim'
vim.cmd 'source ~/.config/nvim/viml/autocmds.vim'
vim.cmd 'source ~/.config/nvim/custom_highlight.vim'
