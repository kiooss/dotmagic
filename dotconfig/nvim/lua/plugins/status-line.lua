local vim = vim
local gl = require('galaxyline')
local fileinfo = require('galaxyline.provider_fileinfo')
local condition = require('galaxyline.condition')
local iconz = require("nvim-nonicons")


local gls = gl.section
gl.short_line_list = {'plug', 'fugitive', 'NvimTree', 'vista', 'dbui', 'packer', 'startify', 'coc'}

-- Functions
local function lsp_status(status)
    local shorter_stat = ''
    for match in string.gmatch(status, "[^%s]+")  do
        local err_warn = string.find(match, "^[WE]%d+", 0)
        if not err_warn then
            shorter_stat = shorter_stat .. ' ' .. match
        end
    end
    return shorter_stat
end


local function get_coc_lsp()
  local status = vim.fn['coc#status']()
  if not status or status == '' then
      return ''
  end
  return lsp_status(status)
end

local function get_diagnostic_info()
  if vim.fn.exists('*coc#rpc#start_server') == 1 then
    return get_coc_lsp()
    end
  return ''
end

CocStatus = get_diagnostic_info

-- Icons
local icons = {
    sep = {
        right = "",
        left = ""
    },
    diagnostic = {
        -- error = " ",
        error = iconz.get("x-circle-fill"),
        -- warn = " ",
        warn = iconz.get("alert"),
        -- info = " "
        info = iconz.get("info"),
        -- hint = "  "
        hint = iconz.get("hint")
    },
    diff = {
        added = iconz.get("diff-added"),
        modified = iconz.get("diff-modified"),
        removed = iconz.get("diff-removed"),
        -- add = " ",
        -- modified = " ",
        -- remove = " "
    },
    git = iconz.get("git-branch"),
    line_nr = iconz.get("list-ordered"),
    file = {
      read_only = '',
      -- modified = '⨁ ',
      -- modified = '✎',
      modified = iconz.get("pencil"),
    },
    normal    = iconz.get("vim-normal-mode"),
    insert    = iconz.get("vim-insert-mode"),
    command   = iconz.get("vim-command-mode"),
    visual    = iconz.get("vim-visual-mode"),
    replace   = iconz.get("vim-replace-mode"),
    selection = iconz.get("vim-select-mode"),
    terminal  = iconz.get("terminal"),
    visual_block = iconz.get("field")
    -- terminal  = iconz.get("vim-terminal-mode")
}

-- Colors
local colors = {
  -- bg = '#282a36',
  bg = "#343d46",
  fg = '#f8f8f2',
  -- section_bg = '#38393f',
  section_bg = '#39313a',
  yellow = '#f1fa8c',
  cyan = '#8be9fd',
  green = '#50fa7b',
  violet = '#a9a1e1',
  orange = '#ffb86c',
  magenta = '#ff79c6',
  blue = '#8be9fd',
  red = '#ff5555'
}

-- -- Local helper functions
-- local in_git_repo = function()
--   local vcs = require('galaxyline.provider_vcs')
--   local branch_name = vcs.get_git_branch()

--   return branch_name ~= nil
-- end

-- local checkwidth = function()
--   return utils.has_width_gt(40) and in_git_repo()
-- end

local mode_color = function()
  local mode_colors = {
    n = colors.cyan,
    i = colors.green,
    c = colors.orange,
    V = colors.magenta,
    [''] = colors.magenta,
    v = colors.magenta,
    R = colors.red,
  }

  local color = mode_colors[vim.fn.mode()]

  if color == nil then
    color = colors.red
  end

  return color
end

local mode_icon = function ()
  local mode_icons = {
    c = "🅒 ", ['!'] = "🅒 ",
    i = "🅘 ", ic    = "🅘 ", ix     = "🅘 ",
    n = "🅝 ",
    R = "🅡 ", Rv    = "🅡 ",
    r = "🅡 ", rm    = "🅡 ", ['r?'] = "🅡 ",
    s = "🅢 ", S     = "🅢 ", [''] = "🅢 ",
    t = "🅣 ",
    v = "🅥 ", V     = "🅥 ", [''] = "🅥 ",
  }

  return mode_icons[vim.fn.mode()]
end

-- Left side
local i = 0

i = i + 1
gls.left[i] = {
  FirstElement = {
    provider = function() return '▋' end,
    highlight = { colors.violet, colors.section_bg }
  },
}

i = i + 1
gls.left[i] = {
  ViMode = {
    provider = function()
      local alias = {
        n = 'NORMAL',
        i = 'INSERT',
        c = 'COMMAND',
        V = 'VISUAL',
        [''] = 'VISUAL',
        v = 'VISUAL',
        R = 'REPLACE',
      }
      vim.api.nvim_command('hi GalaxyViMode guifg='..mode_color()..' gui=bold')
      local alias_mode = alias[vim.fn.mode()]
      if alias_mode == nil then
        alias_mode = vim.fn.mode()
      end
      return mode_icon()..alias_mode..' '
    end,
    highlight = { colors.bg, colors.bg },
    separator = " ",
    separator_highlight = {colors.bg, colors.section_bg},
  },
}


i = i + 1
gls.left[i] ={
  FileIcon = {
    provider = 'FileIcon',
    condition = condition.buffer_not_empty,
    highlight = { require('galaxyline.provider_fileinfo').get_file_icon_color, colors.section_bg },
  },
}

i = i + 1
gls.left[i] = {
  FileName = {
    provider = {'FileName','FileSize'},
    condition = condition.buffer_not_empty,
    highlight = { colors.fg, colors.section_bg, 'bold' },
    separator = " ",
    separator_highlight = {colors.section_bg, colors.bg},
  }
}

i = i + 1
gls.left[i] = {
  GitIcon = {
    provider = function() return ' ' end,
    condition = condition.check_git_workspace,
    highlight = { colors.red, colors.bg },
  }
}

i = i + 1
gls.left[i] = {
  GitBranch = {
    provider = function()
      local vcs = require('galaxyline.provider_vcs')
      local branch_name = vcs.get_git_branch()
      if (string.len(branch_name) > 28) then
        return string.sub(branch_name, 1, 25).."..."
      end
      return branch_name .. " "
    end,
    condition = condition.check_git_workspace,
    highlight = { colors.fg, colors.bg, 'bold,italic'},
  }
}

i = i + 1
gls.left[i] = {
  DiffAdd = {
    provider = 'DiffAdd',
    condition = condition.hide_in_width,
    icon = ' ',
    highlight = { colors.green, colors.bg },
  }
}

i = i + 1
gls.left[i] = {
  DiffModified = {
    provider = 'DiffModified',
    condition = condition.hide_in_width,
    icon = ' ',
    highlight = { colors.orange, colors.bg },
  }
}

i = i + 1
gls.left[i] = {
  DiffRemove = {
    provider = 'DiffRemove',
    condition = condition.hide_in_width,
    icon = ' ',
    highlight = { colors.red,colors.bg },
  }
}

i = i + 1
gls.left[i] = {
  LeftEnd = {
    provider = function() return '' end,
    condition = condition.buffer_not_empty,
    highlight = {colors.section_bg,colors.bg}
  }
}

i = i + 1
gls.left[i] = {
  DiagnosticError = {
    provider = 'DiagnosticError',
    icon = '  ',
    highlight = {colors.red,colors.section_bg}
  }
}

i = i + 1
gls.left[i] = {
  Space = {
    provider = function () return ' ' end,
    highlight = {colors.section_bg,colors.section_bg},
  }
}

i = i + 1
gls.left[i] = {
  DiagnosticWarn = {
    provider = 'DiagnosticWarn',
    icon = '  ',
    highlight = {colors.orange,colors.section_bg},
  }
}

i = i + 1
gls.left[i] = {
  Space = {
    provider = function () return ' ' end,
    highlight = {colors.section_bg,colors.section_bg},
  }
}

i = i + 1
gls.left[i] = {
  DiagnosticHint = {
    provider = 'DiagnosticHint',
    icon = '  ',
    highlight = {colors.blue, colors.section_bg},
  }
}

i = i + 1
gls.left[i] = {
  Space = {
    provider = function () return ' ' end,
    highlight = {colors.section_bg,colors.section_bg},
  }
}

i = i + 1
gls.left[i] = {
  DiagnosticInfo = {
    provider = 'DiagnosticInfo',
    icon = '  ',
    highlight = {colors.blue,colors.section_bg},
    separator = '',
    separator_highlight = { colors.section_bg, colors.bg },
  }
}

-- Mid side
-- gls.mid[1] = {
--   ShowLspClient = {
--     provider = 'GetLspClient',
--     condition = function ()
--       local tbl = {['dashboard'] = true,['']=true}
--       if tbl[vim.bo.filetype] then
--         return false
--       end
--       return true
--     end,
--     icon = '  LSP:',
--     highlight = { colors.cyan, colors.section_bg, 'bold' }
--   }
-- }

gls.mid[1] = {
  CocStatus = {
    provider = CocStatus,
    highlight = {colors.green, colors.section_bg },
  }
}

-- Right side
local i = 0

i = i + 1
gls.right[i]= {
  FileFormat = {
    provider = function() return ' '..vim.bo.filetype..' ' end,
    highlight = { colors.fg, colors.section_bg },
    separator = '',
    separator_highlight = { colors.section_bg, colors.bg },
  }
}

i = i + 1
gls.right[i] = {
  FileEF = { -- {{{2
    highlight = { colors.fg, colors.bg },
    separator = '',
    separator_highlight = { colors.bg, colors.section_bg },

    provider = function ()
      local format_icon = {['DOS'] = " ", ['MAC'] = " ", ['UNIX'] = " "}
      local encode      = fileinfo.get_file_encode()
      local format      = fileinfo.get_file_format()

      return encode..' '..format_icon[format]
    end,
  }
}

i = i + 1
gls.right[i] = {
  LineInfo = {
    provider = 'LineColumn',
    highlight = { colors.fg, colors.section_bg },
    icon = '  ',
    separator = '',
    separator_highlight = { colors.section_bg, colors.bg },
  },
}

i = i + 1
gls.right[i] = {
  PerCent = {
    provider = 'LinePercent',
    highlight = { colors.fg, colors.section_bg },
    -- separator = ' | ',
    separator = " ",
    separator_highlight = { colors.cyan, colors.section_bg },
  },
}

i = i + 1
gls.right[i] = {
  ScrollBar = {
    provider = 'ScrollBar',
    highlight = { colors.cyan, colors.purple },
  }
}

i = i + 1
gls.right[i] = {
  Heart = {
    provider = function() return ' ' end,
    highlight = { colors.red, colors.section_bg },
    separator = ' | ',
    separator_highlight = { colors.bg, colors.section_bg },
  }
}

-- Short status line
gls.short_line_left[1] = {
  BufferType = {
    provider = 'FileTypeName',
    highlight = { colors.fg, colors.section_bg },
    separator = '',
    separator_highlight = { colors.section_bg, colors.bg },
  }
}

gls.short_line_right[1] = {
  BufferIcon = {
    provider= 'BufferIcon',
    highlight = { colors.yellow, colors.section_bg },
    separator = '',
    separator_highlight = { colors.section_bg, colors.bg },
  }
}

-- Force manual load so that nvim boots with a status line
gl.load_galaxyline()
