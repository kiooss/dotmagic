local util = require('util')

local augroup = vim.api.nvim_create_augroup('LspFormatting', {})

local M = {}

-- vim.lsp.handlers["textDocument/hover"] = function(_, method, result)
--   print(vim.inspect(result))
-- end

M.autoformat = true

M.excluded_clients = {
  tsserver = true,
  -- solargraph = true,
}

function M.toggle()
  M.autoformat = not M.autoformat
  if M.autoformat then
    util.info('enabled format on save', 'Formatting')
  else
    util.warn('disabled format on save', 'Formatting')
  end
end

function M.lsp_formatting_create_autocmd(bufnr)
  vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
  vim.api.nvim_create_autocmd('BufWritePre', {
    group = augroup,
    buffer = bufnr,
    callback = function()
      M.lsp_formatting(bufnr)
    end,
  })
end

function M.lsp_formatting(bufnr)
  if not M.autoformat then
    return
  end
  -- vim.lsp.buf.format({ timeout_ms = 10000 })

  vim.lsp.buf.format({
    timeout_ms = 6000,
    bufnr = bufnr,
    filter = function(clients)
      -- filter out clients that you don't want to use
      return vim.tbl_filter(function(client)
        return M.excluded_clients[client.name] == nil
      end, clients)
    end,
  })
end

function M.setup(client, buf)
  local ft = vim.api.nvim_buf_get_option(buf, 'filetype')
  local nls = require('config.lsp.null-ls')

  if client.name == 'null-ls' and not nls.has_formatter(ft) then
    return
  end

  if client.name ~= 'null-ls' and not client.supports_method('textDocument/formatting') then
    return
  end

  M.lsp_formatting_create_autocmd(buf)
end

return M
