return {
  {
    "stevearc/conform.nvim",
    optional = true,
    keys = {
      {
        "<leader>aF",
        function()
          require("conform").format({ formatters = { "rubocopA" } })
        end,
        mode = { "n", "v" },
        desc = "Rubocop auto-correct-all",
      },
    },
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
          condition = function(self, ctx)
            return vim.fs.find({ "dprint.json" }, { path = ctx.filename, upward = true })[1]
          end,
        },
        rubocop = {
          condition = function(self, ctx)
            return vim.fs.find({ ".rubocop.yml" }, { path = ctx.filename, upward = true })[1]
          end,
        },
        rubocopA = {
          command = "rubocop",
          args = {
            "--server",
            "-A",
            "-f",
            "quiet",
            "--stderr",
            "--stdin",
            "$FILENAME",
          },
          exit_codes = { 0, 1 },
        },
        htmlbeautifier = {
          condition = function(self, ctx)
            local full_name = vim.api.nvim_buf_get_name(0)
            return not string.match(full_name, ".*%.text%.erb$")
          end,
        },
      },
    },
  },
}
