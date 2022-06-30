local dashboard = require('dashboard')
local telescope_helper = require('config.telescope.helper')

local f = function(str)
  return string.format('%-38s', str)
end

dashboard.custom_footer = function()
  local str = '🦖 ' .. vim.fn.system('fortune -s')
  local lines = {}
  for s in str:gmatch('[^\r\n]+') do
    table.insert(lines, s)
  end

  return lines
end

dashboard.custom_header = function()
  local fonts = {
    -- 'DOS Rebel',
    -- "NScript",
    -- '3d',
    'ANSI Shadow',
    -- 'Bloody',
    'Elite',
    'maxiwi',
  }
  local header_str = vim.fn.system(
    [[figlet -d $HOME/.dotfiles/vendor/figlet-fonts -f "]] .. fonts[math.random(#fonts)] .. [[" "Yang's neovim"]]
  )
  local header_lines = {}
  for s in header_str:gmatch('[^\r\n]+') do
    table.insert(header_lines, s)
  end
  table.insert(header_lines, '')
  table.insert(header_lines, '')

  return header_lines
end

dashboard.custom_center = {
  {
    icon = '  ',
    desc = f('Recently opened files'),
    shortcut = 'SPC f r',
    action = telescope_helper.oldfiles_cwd_only,
  },
  {
    icon = '  ',
    desc = f('Frecency files'),
    shortcut = 'SPC f f',
    action = telescope_helper.frecency_files,
  },
  {
    icon = '  ',
    desc = f('Marks'),
    shortcut = 'SPC s m',
    action = 'Telescope marks',
  },
  {
    icon = '  ',
    desc = f('Project'),
    shortcut = 'SPC f p',
    action = 'Telescope project',
  },
  {
    icon = '  ',
    desc = f('File browser'),
    shortcut = 'SPC f b',
    action = 'Telescope file_browser',
  },
  {
    icon = '  ',
    desc = f('Find word'),
    shortcut = 'SPC   /',
    action = function()
      require('telescope.builtin').live_grep()
    end,
  },
  {
    icon = '  ',
    desc = f('New file'),
    shortcut = 'SPC f n',
    action = 'DashboardNewFile',
  },
  {
    icon = '  ',
    desc = f('Update plugins'),
    shortcut = 'SPC p s',
    action = 'PackerSync',
  },
  {
    icon = '  ',
    desc = f('Scheme change'),
    shortcut = 'SPC l b',
    action = telescope_helper.colorscheme,
  },
}
