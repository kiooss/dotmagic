local M = {}
M.config = {
  settings = {
    intelephense = {
      files = {
        maxSize = 1000000,
      },
      format = {
        -- TODO: not working?
        enable = false,
      },
      diagnostics = {
        enable = true,
      },
    },
  },
}

return M
