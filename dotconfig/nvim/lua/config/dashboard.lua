vim.g.dashboard_footer_icon = '🦖 '

local str = vim.g.dashboard_footer_icon .. vim.fn.system('fortune -s computers')
local lines = {}
for s in str:gmatch('[^\r\n]+') do
  table.insert(lines, s)
end

vim.g.dashboard_custom_footer = lines

vim.g.dashboard_default_executive = 'telescope'
vim.g.dashboard_enable_session = 0
vim.g.dashboard_disable_statusline = 0

-- vim.g.dashboard_preview_command = "splashcii"
-- vim.g.dashboard_preview_pipeline = "lolcat"
-- vim.g.dashboard_preview_file = "beach"
-- vim.g.dashboard_preview_file_height = 20
-- vim.g.dashboard_preview_file_width = 80

-- vim.g.dashboard_preview_command = "cat"
-- -- vim.g.dashboard_preview_pipeline = "lolcat"
-- vim.g.dashboard_preview_file = "~/.config/nvim/resource/baby2.ans"
-- vim.g.dashboard_preview_file_width = 70
-- vim.g.dashboard_preview_file_height = 29

-- vim.g.dashboard_preview_command = "bat -p"
-- vim.g.dashboard_preview_pipeline = "head -n 30"
-- vim.g.dashboard_preview_file_height = 12
-- vim.g.dashboard_preview_file_width = 80

-- vim.g.dashboard_custom_header = {
--   " ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗",
--   " ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║",
--   " ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║",
--   " ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║",
--   " ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║",
--   " ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝",
-- }

local fonts = {
  'DOS Rebel',
  -- "NScript",
  '3d',
  'ANSI Shadow',
  'Bloody',
  'Elite',
  'maxiwi',
}

if require('core.global').is_mac then
  fonts = { 'slant', 'small' }
end

math.randomseed(os.time())
local header_str = vim.fn.system([[figlet -f "]] .. fonts[math.random(#fonts)] .. [[" "Yang's neovim"]])
local header_lines = {}
for s in header_str:gmatch('[^\r\n]+') do
  table.insert(header_lines, s)
end
vim.g.dashboard_custom_header = header_lines

-- vim.g.dashboard_custom_shortcut = {
--   ["last_session"] = "SPC s l",
--   ["find_history"] = "SPC f r",
--   ["find_file"] = "SPC spc",
--   ["new_file"] = "SPC f n",
--   ["change_colorscheme"] = "SPC h c",
--   ["find_word"] = "SPC f w",
--   ["book_marks"] = "SPC f m",
-- }

local telescope_helper = require('config.telescope.helper')

vim.g.dashboard_custom_section = {
  a = {
    description = { '  Recently opened files (cwd only)        SPC f r' },
    command = telescope_helper.oldfiles_cwd_only,
  },
  b = {
    description = { '  Frecency files                          SPC f f' },
    command = telescope_helper.frecency_files,
  },
  c = {
    description = { '  Marks                                   SPC s m' },
    command = 'Telescope marks',
  },
  d = {
    description = { '  Find file                               SPC spc' },
    command = 'DashboardFindFile',
  },
  e = {
    description = { '  File browser                            SPC f b' },
    command = 'Telescope file_browser',
  },
  f = {
    description = { '  Find word                               SPC f w' },
    command = 'DashboardFindWord',
  },
  g = {
    description = { '  New file                                SPC f n' },
    command = 'enew',
  },
  h = {
    description = { '  Update plugins                          SPC p s' },
    command = 'PackerSync',
  },
}
