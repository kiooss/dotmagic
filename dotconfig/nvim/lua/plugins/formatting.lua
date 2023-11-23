return {
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        ["markdown"] = { { "prettierd", "prettier" } },
        ["markdown.mdx"] = { { "prettierd", "prettier" } },
        ["javascript"] = { "dprint" },
        ["javascriptreact"] = { "dprint" },
        ["typescript"] = { "dprint" },
        ["typescriptreact"] = { "dprint" },
        ["ruby"] = { "rubocop" },
        ["eruby"] = { "htmlbeautifier" },
      },
      formatters = {
        shfmt = {
          prepend_args = { "-i", "2", "-ci" },
        },
        dprint = {
          condition = function(ctx)
            return vim.fs.find({ "dprint.json" }, { path = ctx.filename, upward = true })[1]
          end,
        },
        rubocop = {
          prepend_args = { "--server" },
          condition = function(ctx)
            return vim.fs.find({ ".rubocop.yml" }, { path = ctx.filename, upward = true })[1]
          end,
        },
        htmlbeautifier = {
          condition = function(ctx)
            local full_name = vim.api.nvim_buf_get_name(0)
            return not string.match(full_name, ".*%.text%.erb$")
          end,
        },
      },
    },
  },
}
