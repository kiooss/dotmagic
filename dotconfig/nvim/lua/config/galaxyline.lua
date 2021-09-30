local vim = vim
local gl = require("galaxyline")
local fileinfo = require("galaxyline.provider_fileinfo")
local condition = require("galaxyline.condition")
local colors = require("core.theme")[vim.g.theme]
-- local iconz = require("nvim-nonicons")

local gls = gl.section
gl.short_line_list = {
  "plug",
  "fugitive",
  "NvimTree",
  "vista",
  "dbui",
  "packer",
  "startify",
  "coc",
  "help",
  "dashboard",
  "DiffviewFiles",
}

-- Functions
local white_space = function()
  return " "
end

local function get_lsp_client(msg)
  return function()
    msg = msg or "No Active Lsp"
    local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
    local clients = vim.lsp.get_active_clients()
    if next(clients) == nil then
      return msg
    end

    local lsp_client_names = {}
    for _, client in ipairs(clients) do
      local filetypes = client.config.filetypes
      if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
        table.insert(lsp_client_names, client.name)
      end
    end

    if next(lsp_client_names) == nil then
      return msg
    else
      return table.concat(lsp_client_names, " │ ")
    end
  end
end

local function lsp_status(status)
  local shorter_stat = ""
  for match in string.gmatch(status, "[^%s]+") do
    local err_warn = string.find(match, "^[WE]%d+", 0)
    if not err_warn then
      shorter_stat = shorter_stat .. " " .. match
    end
  end
  return shorter_stat
end

local function get_coc_lsp()
  local status = vim.fn["coc#status"]()
  if not status or status == "" then
    return ""
  end
  return lsp_status(status)
end

local function get_diagnostic_info()
  if vim.fn.exists("*coc#rpc#start_server") == 1 then
    return get_coc_lsp()
  end
  return ""
end

local function coc_current_function()
  if vim.fn.exists("*coc#rpc#start_server") == 1 then
    local ret, current_function = pcall(
      vim.api.nvim_buf_get_var,
      0,
      "coc_current_function"
    )
    if not ret then
      return
    end
    if current_function and current_function ~= "" then
      return " " .. current_function
    end
  end
  return ""
end

CocStatus = get_diagnostic_info

-- Icons
local icons = {
  sep = {
    right = "",
    left = "",
  },
  -- diagnostic = {
  --     -- error = " ",
  --     error = iconz.get("x-circle-fill"),
  --     -- warn = " ",
  --     warn = iconz.get("alert"),
  --     -- info = " "
  --     info = iconz.get("info"),
  --     -- hint = "  "
  --     hint = iconz.get("hint")
  -- },
  -- diff = {
  --     added = iconz.get("diff-added"),
  --     modified = iconz.get("diff-modified"),
  --     removed = iconz.get("diff-removed"),
  --     -- add = " ",
  --     -- modified = " ",
  --     -- remove = " "
  -- },
  -- git = iconz.get("git-branch"),
  line_nr = "",
  -- file = {
  --   read_only = '',
  --   -- modified = '⨁ ',
  --   -- modified = '✎',
  --   modified = iconz.get("pencil"),
  -- },
  -- normal    = iconz.get("vim-normal-mode"),
  -- insert    = iconz.get("vim-insert-mode"),
  -- command   = iconz.get("vim-command-mode"),
  -- visual    = iconz.get("vim-visual-mode"),
  -- replace   = iconz.get("vim-replace-mode"),
  -- selection = iconz.get("vim-select-mode"),
  -- terminal  = iconz.get("terminal"),
  -- visual_block = iconz.get("field")
  -- terminal  = iconz.get("vim-terminal-mode")
}

local mode_color = function()
  local mode_colors = {
    n = colors.cyan,
    i = colors.green,
    c = colors.orange,
    V = colors.magenta,
    [""] = colors.magenta,
    v = colors.magenta,
    R = colors.red,
  }
  local color = mode_colors[vim.fn.mode()]

  if color == nil then
    color = colors.red
  end

  return color
end

local mode_icon = function()
  local mode_icons = {
    c = "🅒 ",
    ["!"] = "🅒 ",
    i = "🅘 ",
    ic = "🅘 ",
    ix = "🅘 ",
    n = "🅝 ",
    R = "🅡 ",
    Rv = "🅡 ",
    r = "🅡 ",
    rm = "🅡 ",
    ["r?"] = "🅡 ",
    s = "🅢 ",
    S = "🅢 ",
    [""] = "🅢 ",
    t = "🅣 ",
    v = "🅥 ",
    V = "🅥 ",
    [""] = "🅥 ",
  }
  return mode_icons[vim.fn.mode()]
end

local cur_section = nil

-- Left side
cur_section = gls.left
table.insert(cur_section, {
  FirstElement = {
    provider = function()
      return "▋"
    end,
    highlight = { colors.violet, colors.section_bg },
  },
})
table.insert(cur_section, {
  ViMode = {
    provider = function()
      local alias = {
        ["n"] = "NORMAL",
        ["no"] = "O-PENDING",
        ["nov"] = "O-PENDING",
        ["noV"] = "O-PENDING",
        ["no"] = "O-PENDING",
        ["niI"] = "NORMAL",
        ["niR"] = "NORMAL",
        ["niV"] = "NORMAL",
        ["v"] = "VISUAL",
        ["V"] = "V-LINE",
        [""] = "V-BLOCK",
        ["s"] = "SELECT",
        ["S"] = "S-LINE",
        [""] = "S-BLOCK",
        ["i"] = "INSERT",
        ["ic"] = "INSERT",
        ["ix"] = "INSERT",
        ["R"] = "REPLACE",
        ["Rc"] = "REPLACE",
        ["Rv"] = "V-REPLACE",
        ["Rx"] = "REPLACE",
        ["c"] = "COMMAND",
        ["cv"] = "EX",
        ["ce"] = "EX",
        ["r"] = "REPLACE",
        ["rm"] = "MORE",
        ["r?"] = "CONFIRM",
        ["!"] = "SHELL",
        ["t"] = "TERMINAL",
      }
      vim.api.nvim_command(
        "hi GalaxyViMode guifg=" .. mode_color() .. " gui=bold"
      )
      local alias_mode = alias[vim.fn.mode()]
      if alias_mode == nil then
        alias_mode = vim.fn.mode()
      end
      return mode_icon() .. alias_mode .. " "
    end,
    highlight = { colors.bg, colors.bg },
    separator = icons.sep.left .. " ",
    separator_highlight = { colors.bg, colors.section_bg },
  },
})
table.insert(cur_section, {
  FileIcon = {
    provider = "FileIcon",
    condition = condition.buffer_not_empty,
    highlight = {
      require("galaxyline.provider_fileinfo").get_file_icon_color,
      colors.section_bg,
    },
  },
})
table.insert(cur_section, {
  FileName = {
    provider = { "FileName", "FileSize" },
    condition = condition.buffer_not_empty,
    highlight = { colors.fg, colors.section_bg, "bold" },
    separator = icons.sep.left .. " ",
    separator_highlight = { colors.section_bg, colors.bg },
  },
})
table.insert(cur_section, {
  GitIcon = {
    provider = function()
      return " "
    end,
    condition = condition.check_git_workspace,
    highlight = { colors.red, colors.bg },
  },
})
table.insert(cur_section, {
  GitBranch = {
    provider = "GitBranch",
    condition = condition.check_git_workspace,
    highlight = { colors.fg, colors.bg, "bold,italic" },
    separator = " ",
    separator_highlight = { colors.section_bg, colors.bg },
  },
})
table.insert(cur_section, {
  DiffAdd = {
    provider = "DiffAdd",
    condition = condition.check_git_workspace and condition.hide_in_width,
    icon = " ",
    highlight = { colors.green, colors.bg },
  },
})
table.insert(cur_section, {
  DiffModified = {
    provider = "DiffModified",
    condition = condition.check_git_workspace and condition.hide_in_width,
    icon = " ",
    highlight = { colors.orange, colors.bg },
  },
})
table.insert(cur_section, {
  DiffRemove = {
    provider = "DiffRemove",
    condition = condition.check_git_workspace and condition.hide_in_width,
    icon = " ",
    highlight = { colors.red, colors.bg },
    separator = icons.sep.left .. " ",
    separator_highlight = { colors.bg, colors.section_bg },
  },
})
table.insert(cur_section, {
  DiagnosticError = {
    provider = "DiagnosticError",
    icon = "  ",
    highlight = { colors.red, colors.section_bg },
  },
})
-- table.insert(cur_section, {
--   Space = {
--     provider = white_space,
--     highlight = { colors.section_bg, colors.section_bg },
--   },
-- })
table.insert(cur_section, {
  DiagnosticWarn = {
    provider = "DiagnosticWarn",
    icon = "  ",
    highlight = { colors.orange, colors.section_bg },
  },
})
-- table.insert(cur_section, {
--   Space = {
--     provider = white_space,
--     highlight = { colors.section_bg, colors.section_bg },
--   },
-- })
table.insert(cur_section, {
  DiagnosticHint = {
    provider = "DiagnosticHint",
    icon = "  ",
    highlight = { colors.cyan, colors.section_bg },
  },
})
-- table.insert(cur_section, {
--   Space = {
--     provider = white_space,
--     highlight = { colors.section_bg, colors.section_bg },
--   },
-- })
table.insert(cur_section, {
  DiagnosticInfo = {
    provider = "DiagnosticInfo",
    icon = "  ",
    highlight = { colors.blue, colors.section_bg },
  },
})
table.insert(cur_section, {
  LeftEnd = {
    provider = white_space,
    condition = condition.buffer_not_empty,
    highlight = { colors.section_bg, colors.section_bg },
    separator = icons.sep.left .. " ",
    separator_highlight = { colors.section_bg, colors.bg },
  },
})
table.insert(cur_section, {
  CurrentFunction = {
    -- provider = coc_current_function,
    provider = "VistaPlugin",
    highlight = { colors.green, colors.bg, "bold,italic" },
  },
})

-- Mid side
cur_section = gls.mid
table.insert(cur_section, {
  ShowLspClient = {
    -- provider = "GetLspClient",
    provider = get_lsp_client("なし"),
    condition = function()
      local tbl = { ["dashboard"] = true, [""] = true }
      if tbl[vim.bo.filetype] then
        return false
      end
      return true
    end,
    icon = " ",
    highlight = { colors.cyan, colors.section_bg, "bold,italic" },
    separator = "",
    separator_highlight = { colors.section_bg, colors.bg },
  },
})
-- table.insert(cur_section, {
--   CocStatus = {
--     provider = CocStatus,
--     highlight = { colors.green, colors.section_bg },
--   },
-- })
table.insert(cur_section, {
  MidEnd = {
    provider = function()
      return ""
    end,
    highlight = { colors.section_bg, colors.bg },
  },
})

-- Right side
cur_section = gls.right
table.insert(cur_section, {
  FileFormat = {
    provider = function()
      return " " .. vim.bo.filetype .. " "
    end,
    highlight = { colors.fg, colors.section_bg, "bold,italic" },
    separator = icons.sep.right,
    separator_highlight = { colors.section_bg, colors.bg },
  },
})
table.insert(cur_section, {
  FileEF = {
    highlight = { colors.fg, colors.bg },
    separator = icons.sep.right,
    separator_highlight = { colors.bg, colors.section_bg },
    provider = function()
      local format_icon = {
        ["DOS"] = " ",
        ["MAC"] = " ",
        ["UNIX"] = " ",
      }
      local encode = fileinfo.get_file_encode()
      local format = fileinfo.get_file_format()

      return encode .. " " .. format_icon[format]
    end,
  },
})
table.insert(cur_section, {
  LineInfo = {
    provider = "LineColumn",
    highlight = { colors.fg, colors.section_bg },
    icon = " " .. icons.line_nr .. " ",
    separator = icons.sep.right,
    separator_highlight = { colors.section_bg, colors.bg },
  },
})
table.insert(cur_section, {
  LineCount = {
    provider = function()
      return vim.fn.line("$")
    end,
    highlight = { colors.fg, colors.section_bg },
    separator = "| ",
    separator_highlight = { colors.red, colors.section_bg },
  },
})
table.insert(cur_section, {
  PerCent = {
    provider = "LinePercent",
    highlight = { colors.fg, colors.section_bg },
    -- separator = ' | ',
    separator = " ",
    separator_highlight = { colors.cyan, colors.section_bg },
  },
})
table.insert(cur_section, {
  ScrollBar = {
    provider = "ScrollBar",
    highlight = { colors.cyan, colors.section_bg },
  },
})
table.insert(cur_section, {
  WhiteSpace = {
    provider = "WhiteSpace",
    highlight = { colors.red, colors.bg, "bold,italic" },
    separator = icons.sep.right,
    separator_highlight = { colors.bg, colors.section_bg },
  },
})
table.insert(cur_section, {
  Heart = {
    provider = function()
      return " "
    end,
    highlight = { colors.red, colors.section_bg },
    separator = icons.sep.right,
    separator_highlight = { colors.section_bg, colors.bg },
  },
})

-- Short status line
cur_section = gls.short_line_left

table.insert(cur_section, {
  RainbowRed = {
    provider = function()
      return "▊ "
    end,
    highlight = { colors.blue, colors.section_bg },
  },
})

table.insert(cur_section, {
  BufferType = {
    provider = "FileTypeName",
    highlight = { colors.fg, colors.section_bg, "bold,italic" },
    separator = icons.sep.left,
    separator_highlight = { colors.section_bg, colors.bg },
  },
})

table.insert(cur_section, {
  SFileName = {
    provider = "SFileName",
    condition = condition.buffer_not_empty,
    highlight = { colors.fg, colors.bg, "bold" },
  },
})

cur_section = gls.short_line_right

table.insert(cur_section, {
  BufferIcon = {
    provider = "BufferIcon",
    highlight = { colors.yellow, colors.section_bg },
    separator = icons.sep.right,
    separator_highlight = { colors.section_bg, colors.bg },
  },
})

-- Force manual load so that nvim boots with a status line
gl.load_galaxyline()
