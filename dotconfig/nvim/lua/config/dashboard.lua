vim.g.dashboard_footer_icon = "🦖 "

local str = vim.g.dashboard_footer_icon .. vim.fn.system("fortune -s computers")
local lines = {}
for s in str:gmatch("[^\r\n]+") do
    table.insert(lines, s)
end

vim.g.dashboard_custom_footer = lines

vim.g.dashboard_default_executive = "telescope"
vim.g.dashboard_enable_session = 0
vim.g.dashboard_disable_statusline = 0

-- vim.g.dashboard_preview_command = "splashcii"
-- vim.g.dashboard_preview_pipeline = "lolcat"
-- vim.g.dashboard_preview_file = "beach"
-- vim.g.dashboard_preview_file_height = 20
-- vim.g.dashboard_preview_file_width = 80

-- vim.g.dashboard_preview_command = "cat"
-- vim.g.dashboard_preview_pipeline = "lolcat"
-- vim.g.dashboard_preview_file = "~/.config/nvim/neovim.cat"

-- vim.g.dashboard_preview_command = "bat -p"
-- vim.g.dashboard_preview_pipeline = "head -n 30"
vim.g.dashboard_preview_file_height = 12
vim.g.dashboard_preview_file_width = 80

-- vim.g.dashboard_custom_header = {
--   " ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗",
--   " ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║",
--   " ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║",
--   " ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║",
--   " ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║",
--   " ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝",
-- }

vim.g.dashboard_custom_shortcut = {
  ["last_session"] = "SPC s l",
  ["find_history"] = "SPC f r",
  ["find_file"] = "SPC spc",
  ["new_file"] = "SPC f n",
  ["change_colorscheme"] = "SPC h c",
  ["find_word"] = "SPC f w",
  ["book_marks"] = "SPC f m"
}
