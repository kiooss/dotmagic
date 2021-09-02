local M = {}

function M.is_buffer_empty()
  -- Check whether the current buffer is empty
  return vim.fn.empty(vim.fn.expand('%:t')) == 1
end

function M.has_width_gt(cols)
  -- Check if the windows width is greater than a given number of columns
  return vim.fn.winwidth(0) / 2 > cols
end

function M.webDevIcons(path)
  local filename = vim.fn.fnamemodify(path, ':t')
  local extension = vim.fn.fnamemodify(path, ':e')
  return require'nvim-web-devicons'.get_icon(filename, extension, { default = true })
end

function M.coc_current_function()
  if vim.fn.exists('*coc#rpc#start_server') == 1 then
    local ret,current_function = pcall(vim.api.nvim_buf_get_var, 0, 'coc_current_function')
    if not ret then return end
    if current_function and current_function ~= '' then
      return ' '..current_function
    end
  end
  return ''
end

return M
