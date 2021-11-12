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
local util = require('lspconfig/util')
local node_root_dir = util.root_pattern(
  '.eslintrc.js',
  '.eslintrc.cjs',
  '.eslintrc.yaml',
  '.eslintrc.yml',
  '.eslintrc.json',
  'package.json'
)

local eslint = require('null-ls.helpers').conditional(function(utils)
  local project_local_bin = './node_modules/.bin/eslint'

  return nls.builtins.formatting.eslint.with({
    command = utils.root_has_file(project_local_bin) and project_local_bin or 'eslint',
    cwd = function(params)
      return node_root_dir(params.bufname)
    end,
  })
end)

local prettier = require('null-ls.helpers').conditional(function(utils)
  local project_local_bin = './node_modules/.bin/prettier'

  return nls.builtins.formatting.prettier.with({
    command = utils.root_has_file(project_local_bin) and project_local_bin or 'prettier',
    cwd = function(params)
      return node_root_dir(params.bufname)
    end,
  })
end)

function M.setup(options)
  nls.config({
    debug = true,
    debounce = 150,
    save_after_format = false,
    sources = {
      -- formatters
      nls.builtins.formatting.fixjson.with({ filetypes = { 'jsonc' } }),
      prettier,
      eslint,
      -- nls.builtins.formatting.prettier,
      -- nls.builtins.formatting.eslint,
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

  require('lspconfig')['null-ls'].setup(options)
end

function M.has_formatter(ft)
  local formatters = require('null-ls.info').get_active_sources()['NULL_LS_FORMATTING']
  if formatters then
    return true
  end
  return false
end

return M
