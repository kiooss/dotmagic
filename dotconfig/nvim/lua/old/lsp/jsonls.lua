local M = {}

M.config = {
  filetypes = { 'json', 'jsonc' },
  settings = {
    json = {
      schemas = require('schemastore').json.schemas(),
    },
  },
}

return M
