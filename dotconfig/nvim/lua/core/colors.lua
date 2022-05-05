local colors = {}
local vim = vim

-- bg should be same with StatusLine bg color.
colors.default = function()
  return {
    bg = '#202328',
    section_bg = '#2c3043',
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
    pink = '#f9c8c8',
  }
end

colors.tokyonight = function()
  local tokyonight_colors = require('tokyonight.colors').setup({})
  return vim.tbl_deep_extend('force', colors.default, tokyonight_colors, {
    bg = tokyonight_colors.bg_statusline,
    section_bg = tokyonight_colors.bg_highlight,
    border = tokyonight_colors.border_highlight,
  })
end

colors['rose-pine'] = function()
  local palette = require('rose-pine.palette')
  return {
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
end

colors.everforest = function()
  return {
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
end

colors.aurora = function()
  return {
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
end

colors.sonokai = function()
  return {
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
end

colors.nightfly = function()
  return {
    bg = '#2c3043',
    fg = '#acb4c2',
    section_bg = '#011627',
    yellow = '#ecc48d',
    cyan = '#7fdbca',
    green = '#21c7a8',
    violet = '#ae81ff',
    orange = '#ecc48d',
    magenta = '#ae81ff',
    blue = '#82aaff',
    red = '#ff5874',
  }
end

local fox_themes = {
  'nightfox',
  'dayfox',
  'dawnfox',
  'duskfox',
  'nordfox',
  'terafox',
}

for _, theme in ipairs(fox_themes) do
  colors[theme] = function()
    local palette = require('nightfox.palette').load(theme)
    return {
      bg = palette.bg3,
      fg = palette.fg4,
      section_bg = palette.bg2,
      yellow = palette.yellow.base,
      cyan = palette.cyan.base,
      green = palette.green.base,
      violet = '#ae81ff',
      orange = palette.orange.base,
      magenta = palette.magenta.base,
      blue = palette.blue.base,
      red = palette.red.base,
      pink = palette.pink.base,
    }
  end
end

return colors
