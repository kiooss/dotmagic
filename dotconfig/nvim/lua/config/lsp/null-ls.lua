local M = {}

-- (arch)
-- pacman -S shfmt shellcheck
-- (mac)
-- brew install shfmt
-- (npm)
-- npm i -g markdownlint-cli
-- (rust)
-- cargo install stylua

function M.setup()
  local nls = require('null-ls')
  local util = require('lspconfig/util')
  local node_root_dir = util.root_pattern(
    '.eslintrc.js',
    '.eslintrc.cjs',
    '.eslintrc.yaml',
    '.eslintrc.yml',
    '.eslintrc.json',
    'package.json'
  )

  nls.config({
    debug = false,
    debounce = 150,
    save_after_format = false,
    sources = {
      -- formatters
      -- nls.builtins.formatting.prettierd,
      -- nls.builtins.formatting.eslint_d.with({
      --   cwd = function(params)
      --     return node_root_dir(params.bufname)
      --   end,
      -- }),
      nls.builtins.formatting.stylua.with({
        extra_args = {
          '--config-path',
          vim.fn.expand('~/.config/nvim/.stylua'),
          '-',
        },
      }),
      nls.builtins.formatting.shfmt.with({
        extra_args = { '-i', '2', '-ci' },
      }),
      nls.builtins.formatting.sqlformat.with({
        extra_args = { '-r' },
      }),
      -- nls.builtins.formatting.phpcsfixer.with({
      --   command = "php-cs-fixer",
      -- }),

      -- diagnostics
      -- nls.builtins.diagnostics.eslint_d.with({
      --   cwd = function(params)
      --     return node_root_dir(params.bufname)
      --   end,
      -- }),
      nls.builtins.diagnostics.shellcheck.with({
        condition = function()
          local filename_exclude = {
            '.*%.env$',
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

      -- code_actions
      nls.builtins.code_actions.gitsigns,
    },
  })
end

function M.has_formatter(ft)
  local config = require('null-ls.config').get()
  local formatters = config._generators['NULL_LS_FORMATTING']
  for _, f in ipairs(formatters) do
    if vim.tbl_contains(f.filetypes, ft) then
      return true
    end
  end
end

return M
