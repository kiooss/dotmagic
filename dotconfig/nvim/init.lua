-- =============================================================================
--  init.lua --- Lua Config Entry file for neovim
-- =============================================================================
-- enable before the first require so util.debug / config.lazy are byte-cached too
if vim.loader then
  vim.loader.enable()
end

local debug = require("util.debug")

if vim.env.VIMCONFIG then
  return debug.switch(vim.env.VIMCONFIG)
end

require("config.lazy")()
