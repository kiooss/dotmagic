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
  local nightfox = require('nightfox')

  -- This function set the configuration of nightfox. If a value is not passed in the setup function
  -- it will be taken from the default configuration above
  nightfox.setup({
    fox = 'nightfox', -- change the colorscheme to use nordfox
    -- fox = 'dawnfox', -- change the colorscheme to use nordfox
    styles = {
      -- comments = 'italic', -- change style of comments to be italic
      keywords = 'bold', -- change style of keywords to be bold
      functions = 'italic,bold', -- styles can be a comma separated list
      strings = 'NONE', -- Style that is applied to strings: see `highlight-args` for options
      variables = 'NONE', -- Style that is applied to variables: see `highlight-args` for options
    },
    inverse = {
      match_paren = true, -- inverse the highlighting of match_parens
      visual = true, -- Enable/Disable inverse highlighting for visual selection
      search = true, -- Enable/Disable inverse highlights for search highlights
    },
    -- colors = {
    --   red = '#FF000', -- Override the red color for MAX POWER
    --   bg_alt = '#000000',
    -- },
    hlgroups = {
      -- TSPunctDelimiter = { fg = '${red}' }, -- Override a highlight group with the color red
      -- LspCodeLens = { bg = '#000000', style = 'italic' },
      -- LspReferenceRead = { style = 'italic,underline' },
    },
  })

  -- Load the configuration set above and apply the colorscheme
  nightfox.load()
end

function config.catppuccin()
  local catppuccin = require('catppuccin')

  -- configure it
  catppuccin.setup({
    transparent_background = false,
    term_colors = false,
    styles = {
      comments = 'italic',
      functions = 'bold,italic',
      keywords = 'italic',
      strings = 'NONE',
      variables = 'italic',
    },
    integrations = {
      treesitter = true,
      native_lsp = {
        enabled = true,
        virtual_text = {
          errors = 'italic',
          hints = 'italic',
          warnings = 'italic',
          information = 'italic',
        },
        underlines = {
          errors = 'undercurl',
          hints = 'undercurl',
          warnings = 'undercurl',
          information = 'undercurl',
        },
      },
      lsp_trouble = false,
      cmp = true,
      lsp_saga = false,
      gitgutter = false,
      gitsigns = true,
      telescope = true,
      nvimtree = {
        enabled = true,
        show_root = false,
        transparent_panel = true,
      },
      neotree = {
        enabled = false,
        show_root = false,
        transparent_panel = false,
      },
      which_key = true,
      indent_blankline = {
        enabled = true,
        colored_indent_levels = true,
      },
      dashboard = true,
      neogit = false,
      vim_sneak = false,
      fern = false,
      barbar = false,
      bufferline = true,
      markdown = true,
      lightspeed = false,
      ts_rainbow = false,
      hop = false,
      notify = true,
      telekasten = true,
      symbols_outline = true,
    },
  })
end

function config.setup(theme)
  theme = theme:gsub('-', '_')

  if theme:match('.*fox$') then
    config.nightfox()
  else
    if config[theme] then
      config[theme]()
    end
    vim.cmd('colorscheme ' .. theme)
  end
end

return config
