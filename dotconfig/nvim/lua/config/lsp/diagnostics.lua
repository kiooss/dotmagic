local util = require('util')

local M = {}

-- vim.lsp.handlers["textDocument/hover"] = function(_, method, result)
--   print(vim.inspect(result))
-- end

M.display = true

function M.toggle()
  M.display = not M.display
  if M.display then
    vim.diagnostic.show()
    util.info('show diagnostics', 'LSP')
  else
    vim.diagnostic.hide()
    util.warn('hide diagnostics', 'LSP')
  end
end

function M.setup()
  -- Automatically update diagnostics
  vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = true,
    update_in_insert = false,
    virtual_text = { spacing = 4, prefix = ' ' },
    severity_sort = true,
  })

  local signs = { Error = ' ', Warn = ' ', Hint = ' ', Info = ' ' }

  for type, icon in pairs(signs) do
    local hl = 'DiagnosticSign' .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = '' })
  end

  -- null-ls using the new diagnostic API
  vim.diagnostic.config({
    underline = true,
    virtual_text = { spacing = 4, prefix = ' ' },
    signs = true,
    update_in_insert = false,
    severity_sort = true,
  })
end

return M
