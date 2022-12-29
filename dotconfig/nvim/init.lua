-- =============================================================================
--  init.lua --- Lua Config Entry file for neovim
--  => Yang Yang
-- =============================================================================
require('util.debug')
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require('config.lazy')
require('config.options')

vim.api.nvim_create_autocmd('User', {
  pattern = 'VeryLazy',
  callback = function()
    require('util').version()
    require('config.events')
    require('config.mappings')
  end,
})
