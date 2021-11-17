local vim = vim
local theme = vim.g.theme

if theme == 'tokyonight' then
  -- @usage 'day' | 'storm' | 'night'
  vim.g.tokyonight_style = 'night'
  vim.g.tokyonight_sidebars = {
    'qf',
    'vista_kind',
    'terminal',
    'packer',
    'spectre_panel',
    'NeogitStatus',
    'help',
    'NvimTree',
  }
  vim.g.tokyonight_terminal_colors = true
  vim.g.tokyonight_italic_comments = true
  vim.g.tokyonight_italic_keywords = true
  vim.g.tokyonight_italic_functions = true
  vim.g.tokyonight_italic_variables = true
  vim.g.tokyonight_transparent = false
  vim.g.tokyonight_hide_inactive_statusline = false
  vim.g.tokyonight_dark_sidebar = true
  vim.g.tokyonight_dark_float = true
  vim.g.tokyonight_colors = { hint = 'orange', error = '#ff0000' }
elseif theme == 'rose-pine' then
  -- Set variant
  -- Defaults to 'dawn' if vim background is light
  -- @usage 'base' | 'moon' | 'dawn' | 'rose-pine[-moon][-dawn]'
  vim.g.rose_pine_variant = 'rose-pine-moon'
  -- Disable italics
  vim.g.rose_pine_disable_italics = false
  -- Use terminal background
  vim.g.rose_pine_disable_background = false
  -- Toggle variant
  vim.api.nvim_set_keymap(
    'n',
    '<c-0>',
    [[<cmd>lua require('rose-pine.functions').toggle_variant()<cr>]],
    { noremap = true, silent = true }
  )
elseif theme == 'everforest' then
  -- Available values: `'hard'`, `'medium'`, `'soft'`
  vim.g.everforest_background = 'medium'
  vim.g.everforest_enable_italic = 1
  vim.g.everforest_diagnostic_text_highlight = 1
  -- vim.g.everforest_transparent_background = 1
  vim.g.everforest_diagnostic_virtual_text = 'colored'
elseif theme == 'aurora' then
  vim.g.aurora_italic = 1
  vim.g.aurora_bold = 1
elseif theme == 'sonokai' then
  -- Available values: `'default'`, `'atlantis'`, `'andromeda'`, `'shusia'`, `'maia'`, `'espresso'`
  vim.g.sonokai_style = 'maia'
  vim.g.sonokai_enable_italic = 1
  -- vim.g.sonokai_disable_italic_comment = 1
  vim.g.sonokai_diagnostic_virtual_text = 'colored'
end

vim.cmd('colorscheme ' .. theme)
