local theme = {}
local tokyonight_colors = require("tokyonight.colors").setup({})

theme.default = {
  bg = "#202328",
  fg = "#bbc2cf",
  yellow = "#ECBE7B",
  cyan = "#008080",
  darkblue = "#081633",
  green = "#98be65",
  orange = "#FF8800",
  violet = "#a9a1e1",
  magenta = "#c678dd",
  blue = "#51afef",
  red = "#ec5f67",
}

theme.tokyonight = vim.tbl_deep_extend("force", tokyonight_colors, {
  bg = tokyonight_colors.bg_statusline,
  section_bg = tokyonight_colors.bg_highlight,
})

theme["rose-pine"] = {
  bg = "#2a273f",
  fg = "#f8f8f2",
  section_bg = "#39313a",
  yellow = "#f1fa8c",
  cyan = "#8be9fd",
  green = "#50fa7b",
  violet = "#a9a1e1",
  orange = "#ffb86c",
  magenta = "#ff79c6",
  blue = "#8be9fd",
  red = "#ff5555",
}

theme.everforest = {
  bg = "#374247",
  fg = "#d3c6aa",
  section_bg = "#2f383e",
  yellow = "#f1fa8c",
  cyan = "#7fbbb3",
  green = "#50fa7b",
  violet = "#a9a1e1",
  orange = "#ffb86c",
  magenta = "#ff79c6",
  blue = "#8be9fd",
  red = "#ff5555",
}

return theme
