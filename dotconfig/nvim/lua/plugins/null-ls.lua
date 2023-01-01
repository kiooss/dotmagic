local M = {
  'jose-elias-alvarez/null-ls.nvim',
}

function M.setup(options)
  local null_ls = require('null-ls')
  null_ls.setup({
    debug = false,
    debounce = 250,
    default_timeout = 10000,
    on_attach = options.on_attach,
    root_dir = require('null-ls.utils').root_pattern('.null-ls-root', '.neoconf.json', '.git'),
    should_attach = function(bufnr)
      return not vim.api.nvim_buf_get_name(bufnr):match('__FLUTTER_DEV_LOG__')
    end,
    sources = {
      -- formatters
      null_ls.builtins.formatting.fixjson.with({ filetypes = { 'jsonc' } }),
      null_ls.builtins.formatting.prettier.with({ prefer_local = 'node_modules/.bin' }),
      null_ls.builtins.formatting.eslint.with({ prefer_local = 'node_modules/.bin' }),
      null_ls.builtins.formatting.stylua.with({
        extra_args = {
          '--config-path',
          vim.fn.expand('~/.config/nvim/.stylua.toml'),
          '-',
        },
      }),
      null_ls.builtins.formatting.shfmt.with({
        extra_args = { '-i', '2', '-ci' },
      }),
      null_ls.builtins.formatting.sqlformat.with({
        extra_args = { '-r' },
      }),
      null_ls.builtins.formatting.rubocop,

      -- diagnostics
      null_ls.builtins.diagnostics.shellcheck.with({
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
      null_ls.builtins.diagnostics.markdownlint,
      -- nls.builtins.diagnostics.pylint,

      -- code_actions
      null_ls.builtins.code_actions.gitsigns,

      -- hover
      null_ls.builtins.hover.dictionary,
    },
  })
end

function M.has_formatter(ft)
  local null_ls = require('null-ls')
  local null_ls_sources = require('null-ls.sources')
  return #vim.tbl_filter(function(source)
    -- you could also filter by source name here
    return null_ls_sources.is_available(source, ft, null_ls.methods.FORMATTING)
  end, null_ls_sources.get({})) > 0
end

return M
