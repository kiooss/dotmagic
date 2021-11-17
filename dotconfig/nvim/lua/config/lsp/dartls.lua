local M = {}

function M.setup(options)
  local config = {}
  require('lspconfig')['dartls'].setup(vim.tbl_deep_extend('force', options, config))
end

return M
