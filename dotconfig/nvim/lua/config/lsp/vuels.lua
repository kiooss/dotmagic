local M = {}
M.config = {
  settings = {
    vetur = {
      format = {
        enable = false,
        options = {
          tabSize = 2,
        },
      },
      validation = {
        -- https://vuejs.github.io/vetur/guide/linting-error.html#error-checking
        template = true,
      },
    },
  },
}

return M
