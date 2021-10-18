local theme = {}
local vim = vim

theme.default = {
  bg = '#202328',
  fg = '#bbc2cf',
  yellow = '#ECBE7B',
  cyan = '#008080',
  darkblue = '#081633',
  green = '#98be65',
  orange = '#FF8800',
  violet = '#a9a1e1',
  magenta = '#c678dd',
  blue = '#51afef',
  red = '#ec5f67',
}

local tokyonight_colors = require('tokyonight.colors').setup({})

theme.tokyonight = vim.tbl_deep_extend('force', tokyonight_colors, {
  bg = tokyonight_colors.bg_statusline,
  section_bg = tokyonight_colors.bg_highlight,
})

local palette = require('rose-pine.palette')

theme['rose-pine'] = {
  bg = palette.surface,
  section_bg = '#39313a',
  fg = palette.text,
  fg_alt = palette.subtle,
  yellow = palette.gold,
  cyan = palette.foam,
  green = palette.pine,
  orange = palette.rose,
  magenta = palette.iris,
  blue = palette.subtle,
  red = palette.love,
}

theme.everforest = {
  bg = '#374247',
  fg = '#d3c6aa',
  section_bg = '#2f383e',
  yellow = '#f1fa8c',
  cyan = '#7fbbb3',
  green = '#50fa7b',
  violet = '#a9a1e1',
  orange = '#ffb86c',
  magenta = '#ff79c6',
  blue = '#8be9fd',
  red = '#ff5555',
}

theme.aurora = {
  bg = '#443a54',
  fg = vim.g.terminal_color_14,
  section_bg = '#2f383e',
  yellow = '#f1fa8c',
  cyan = '#7fbbb3',
  green = '#50fa7b',
  violet = '#a9a1e1',
  orange = '#ffb86c',
  magenta = '#ff79c6',
  blue = '#8be9fd',
  red = '#ff5555',
}

theme.sonokai = {
  fg = '#bbc2cf',
  bg = '#393e53',
  section_bg = '#2f383e',
  yellow = '#f1fa8c',
  cyan = '#7fbbb3',
  green = '#50fa7b',
  violet = '#a9a1e1',
  orange = '#ffb86c',
  magenta = '#ff79c6',
  blue = '#8be9fd',
  red = '#ff5555',
}

return theme
