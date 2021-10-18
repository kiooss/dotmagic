-- =============================================================================
--  init.lua --- Lua Config Entry file for neovim
--  => Yang Yang
-- =============================================================================
local ok, err = pcall(require, 'core')

if not ok then
  error('Error loading core' .. '\n\n' .. err)
end
