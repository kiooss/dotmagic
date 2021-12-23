-- (arch)
-- pacman -S shfmt shellcheck
-- (mac)
-- brew install shfmt
-- (npm)
-- npm i -g markdownlint-cli prettier
-- (rust)
-- cargo install stylua

local M = {}
local nls = require('null-ls')

function M.setup(options)
  nls.setup({
    debug = false,
    debounce = 250,
    save_after_format = false,
    on_attach = options.on_attach,
    sources = {
      -- formatters
      nls.builtins.formatting.fixjson.with({ filetypes = { 'jsonc' } }),
      nls.builtins.formatting.prettier.with({ prefer_local = 'node_modules/.bin' }),
      nls.builtins.formatting.eslint.with({ prefer_local = 'node_modules/.bin' }),
      nls.builtins.formatting.stylua.with({
        extra_args = {
          '--config-path',
          vim.fn.expand('~/.config/nvim/.stylua.toml'),
          '-',
        },
      }),
      nls.builtins.formatting.shfmt.with({
        extra_args = { '-i', '2', '-ci' },
      }),
      nls.builtins.formatting.sqlformat.with({
        extra_args = { '-r' },
      }),

      -- diagnostics
      nls.builtins.diagnostics.shellcheck.with({
        condition = function()
          local filename_exclude = {
            '.*%.env$',
            '.*%.env%..*$',
          }
          local full_name = vim.api.nvim_buf_get_name(0)
          for _, pattern in ipairs(filename_exclude) do
            if string.match(full_name, pattern) then
              return false
            end
          end

          return true
        end,
      }),
      nls.builtins.diagnostics.markdownlint,
      -- nls.builtins.diagnostics.pylint,

      -- code_actions
      nls.builtins.code_actions.gitsigns,

      -- hover
      nls.builtins.hover.dictionary,
    },
  })
end

function M.has_formatter(ft)
  local formatters = require('null-ls.info').get_active_sources()['NULL_LS_FORMATTING']
  if formatters then
    return true
  end
  return false
end

return M
