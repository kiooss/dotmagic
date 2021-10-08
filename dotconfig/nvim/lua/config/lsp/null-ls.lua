local M = {}

function M.setup()
  local nls = require("null-ls")

  nls.config({
    debug = true,
    debounce = 150,
    save_after_format = false,
    sources = {
      -- formatters
      -- nls.builtins.formatting.prettierd,
      nls.builtins.formatting.stylua.with({
        extra_args = {
          "--config-path",
          vim.fn.expand("~/.config/nvim/.stylua"),
          "-",
        },
      }),
      -- nls.builtins.formatting.eslint_d,
      nls.builtins.formatting.shfmt.with({
        extra_args = { "-i", "2", "-ci" },
      }),
      nls.builtins.formatting.sqlformat.with({
        extra_args = { "-r" },
      }),
      -- nls.builtins.formatting.phpcsfixer.with({
      --   command = "php-cs-fixer",
      -- }),

      -- diagnostics
      nls.builtins.diagnostics.shellcheck,
      nls.builtins.diagnostics.markdownlint,
      -- nls.builtins.diagnostics.selene,

      -- code_actions
      nls.builtins.code_actions.gitsigns,
    },
  })
end

function M.has_formatter(ft)
  local config = require("null-ls.config").get()
  local formatters = config._generators["NULL_LS_FORMATTING"]
  for _, f in ipairs(formatters) do
    if vim.tbl_contains(f.filetypes, ft) then
      return true
    end
  end
end

return M
