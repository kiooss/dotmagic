-- selene: allow(global_usage)
_G.dump = function(...)
  print(vim.inspect(...))
end

-- selene: allow(global_usage)
_G.profile = function(cmd, times)
  times = times or 100
  local args = {}
  if type(cmd) == 'string' then
    args = { cmd }
    cmd = vim.cmd
  end
  local start = vim.loop.hrtime()
  for _ = 1, times, 1 do
    local ok = pcall(cmd, unpack(args))
    if not ok then
      error('Command failed: ' .. tostring(ok) .. ' ' .. vim.inspect({ cmd = cmd, args = args }))
    end
  end
  print(((vim.loop.hrtime() - start) / 1000000 / times) .. 'ms')
end

-- selene: allow(global_usage)
_G.should_colorcolumn = function()
  local filetype_exclude = {
    'diff',
    'packer',
    'fugitiveblame',
    'undotree',
    'nerdtree',
    'qf',
    'list',
    'dashboard',
    'startify',
    'DiffviewFiles',
  }

  for _, ft in ipairs(filetype_exclude) do
    if ft == vim.bo.filetype then
      return false
    end
  end

  return true
end

_G.P = function(v)
  print(vim.inspect(v))
  return v
end

-- Debug Notification
-- (value, context_message)
_G.DN = function(v, cm)
  local time = os.date('%H:%M')
  local context_msg = cm or ' '
  local msg = context_msg .. ' ' .. time
  require('notify')(vim.inspect(v), 'debug', { title = { 'Debug Output', msg } })
  return v
end

_G.RELOAD = function(...)
  return require('plenary.reload').reload_module(...)
end

_G.R = function(name)
  RELOAD(name)
  return require(name)
end

local M = {}

function M.t(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

function M.log(msg, level, name)
  name = name or 'Neovim'
  local hl_map = {
    info = 'DiagnosticInfo',
    warn = 'DiagnosticWarn',
    error = 'DiagnosticError',
  }
  local hl = hl_map[level] or 'Todo'
  vim.notify(msg, level, { title = name })
  vim.api.nvim_echo({ { name .. ': ', hl }, { msg } }, true, {})
end

function M.warn(msg, name)
  M.log(msg, 'warn', name)
end

function M.error(msg, name)
  M.log(msg, 'error', name)
end

function M.info(msg, name)
  M.log(msg, 'info', name)
end

function M.toggle(option, silent)
  local info = vim.api.nvim_get_option_info(option)
  local scopes = { buf = 'bo', win = 'wo', global = 'o' }
  local scope = scopes[info.scope]
  local options = vim[scope]
  options[option] = not options[option]
  if silent ~= true then
    if options[option] then
      M.info('enabled vim.' .. scope .. '.' .. option, 'Toggle')
    else
      M.warn('disabled vim.' .. scope .. '.' .. option, 'Toggle')
    end
  end
end

function M.float_terminal(cmd)
  local buf = vim.api.nvim_create_buf(false, true)
  local vpad = 4
  local hpad = 10
  local win = vim.api.nvim_open_win(buf, true, {
    relative = 'editor',
    width = vim.o.columns - hpad * 2,
    height = vim.o.lines - vpad * 2,
    row = vpad,
    col = hpad,
    style = 'minimal',
    border = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
  })
  vim.fn.termopen(cmd)
  local autocmd = {
    'autocmd! TermClose <buffer> lua',
    string.format('vim.api.nvim_win_close(%d, {force = true});', win),
    string.format('vim.api.nvim_buf_delete(%d, {force = true});', buf),
  }
  vim.cmd(table.concat(autocmd, ' '))
  vim.cmd([[startinsert]])
end

function M.docs()
  local name = vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
  local docgen = require('babelfish')
  vim.fn.mkdir('./doc', 'p')
  local metadata = {
    input_file = './README.md',
    output_file = 'doc/' .. name .. '.txt',
    project_name = name,
  }
  docgen.generate_readme(metadata)
end

function M.lsp_config()
  local ret = {}
  for _, client in pairs(vim.lsp.get_active_clients()) do
    ret[client.name] = {
      root_dir = client.config.root_dir,
      settings = client.config.settings,
    }
  end
  dump(ret)
end

return M
