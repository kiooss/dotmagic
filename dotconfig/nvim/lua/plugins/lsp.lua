return {
  -- neodev
  {
    "folke/neodev.nvim",
    opts = {
      debug = true,
      experimental = {
        pathStrict = true,
      },
      library = {
        runtime = "~/projects/neovim/runtime/",
      },
    },
  },

  -- lsp servers
  {
    "neovim/nvim-lspconfig",
    opts = {
      format = { timeout_ms = 10000 },

      ---@type lspconfig.options
      servers = {
        bashls = {},
        clangd = {
          capabilities = {
            offsetEncoding = { "utf-16" },
          },
        },
        cssls = {},
        dockerls = {},
        tsserver = {},
        eslint = {},
        html = {},
        intelephense = {},
        pyright = {},
        -- rust_analyzer = {
        --   settings = {
        --     ["rust-analyzer"] = {
        --       cargo = { allFeatures = true },
        --       checkOnSave = {
        --         command = "clippy",
        --         extraArgs = { "--no-deps" },
        --       },
        --     },
        --   },
        -- },
        yamlls = {},
        solargraph = {},
        vimls = {},
        vuels = {},
      },
    },
  },

  -- null-ls
  {
    "jose-elias-alvarez/null-ls.nvim",
    config = function()
      local nls = require("null-ls")
      nls.setup({
        -- debounce = 150,
        default_timeout = 10000,
        -- should_attach = function(bufnr)
        --   return not vim.api.nvim_buf_get_name(bufnr):match("__FLUTTER_DEV_LOG__")
        -- end,
        sources = {
          -- formatters
          nls.builtins.formatting.fixjson.with({ filetypes = { "jsonc" } }),
          nls.builtins.formatting.prettier.with({ prefer_local = "node_modules/.bin" }),
          nls.builtins.formatting.eslint.with({ prefer_local = "node_modules/.bin" }),
          nls.builtins.formatting.stylua.with({
            extra_args = {
              "--config-path",
              vim.fn.expand("~/.config/nvim/.stylua.toml"),
              "-",
            },
          }),
          nls.builtins.formatting.shfmt.with({
            extra_args = { "-i", "2", "-ci" },
          }),
          nls.builtins.formatting.sqlformat.with({
            extra_args = { "-r" },
          }),
          nls.builtins.formatting.rubocop,

          -- diagnostics
          nls.builtins.diagnostics.shellcheck.with({
            condition = function()
              local filename_exclude = {
                ".*%.env$",
                ".*%.env%..*$",
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
        root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", ".git"),
      })
    end,
  },

  -- cmdline tools and lsp servers
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "fixjson",
        "prettier",
        "rubocop",
        "stylua",
        "shellcheck",
        "shfmt",
      },
    },
  },
}
