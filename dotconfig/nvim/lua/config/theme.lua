local vim = vim

local config = {}

function config.tokyonight()
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
end

function config.rose_pine()
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
end

function config.everforest()
  -- Available values: `'hard'`, `'medium'`, `'soft'`
  vim.g.everforest_background = 'medium'
  vim.g.everforest_enable_italic = 1
  vim.g.everforest_diagnostic_text_highlight = 1
  -- vim.g.everforest_transparent_background = 1
  vim.g.everforest_diagnostic_virtual_text = 'colored'
end

function config.aurora()
  vim.g.aurora_italic = 1
  vim.g.aurora_bold = 1
end

function config.sonokai()
  -- Available values: `'default'`, `'atlantis'`, `'andromeda'`, `'shusia'`, `'maia'`, `'espresso'`
  vim.g.sonokai_style = 'maia'
  vim.g.sonokai_enable_italic = 1
  -- vim.g.sonokai_disable_italic_comment = 1
  vim.g.sonokai_diagnostic_virtual_text = 'colored'
end

function config.nightfox()
  require('nightfox').setup({
    options = {
      styles = {
        comments = 'italic',
        keywords = 'bold',
        types = 'italic,bold',
      },
      inverse = { -- Inverse highlight for different types
        match_paren = true,
        visual = true,
        search = false,
      },
    },
  })
end

function config.catppuccin()
  vim.g.catppuccin_flavour = 'macchiato' -- latte, frappe, macchiato, mocha
  local catppuccin = require('catppuccin')
  -- configure it
  catppuccin.setup({})
end

function config.setup(theme)
  theme = theme:gsub('-', '_')

  if
    not pcall(function()
      if theme:match('.*fox$') then
        config.nightfox()
      else
        if config[theme] then
          config[theme]()
        end
      end
      vim.cmd('colorscheme ' .. theme)
    end)
  then
    print('Theme not found: ' .. theme)
  end
end

return config
