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
      format = { timeout_ms = 60000 },

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
        yamlls = {
          capabilities = {
            textDocument = {
              foldingRange = false,
            },
          },
        },
        solargraph = {
          mason = false, -- set to false if you don't want this server to be installed with mason
        },
        vimls = {},
        vuels = {},
        -- tailwindcss = {},
      },
    },
  },

  -- null-ls
  {
    "nvimtools/none-ls.nvim",
    opts = function(_, opts)
      local nls = require("null-ls")
      vim.list_extend(opts, {
        debug = true,
        -- debounce = 150,
        default_timeout = 60000,
        root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", ".git"),
      })
      vim.list_extend(opts.sources, {
        -- formatters
        nls.builtins.formatting.fixjson.with({ filetypes = { "jsonc" } }),
        nls.builtins.formatting.prettier.with({ prefer_local = "node_modules/.bin" }),
        nls.builtins.formatting.eslint.with({
          prefer_local = "node_modules/.bin",
          condition = function(utils)
            return utils.root_has_file({
              ".eslintrc.js",
              ".eslintrc.cjs",
              ".eslintrc.yaml",
              ".eslintrc.yml",
              ".eslintrc.json",
            })
          end,
        }),
        nls.builtins.formatting.stylua.with({
          condition = function(utils)
            return utils.root_has_file({ "stylua.toml", ".stylua.toml" })
          end,
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
        -- nls.builtins.formatting.rubocop.with({
        --   extra_args = { "--server" },
        --   condition = function(utils)
        --     return utils.root_has_file({ ".rubocop.yml" })
        --   end,
        -- }),
        -- nls.builtins.formatting.erb_lint,
        -- nls.builtins.formatting.erb_format.with({
        --   condition = function()
        --     local full_name = vim.api.nvim_buf_get_name(0)
        --     return not string.match(full_name, ".*%.text%.erb$")
        --   end,
        --   extra_args = { "--print-width", "120" },
        -- }),
        -- nls.builtins.formatting.htmlbeautifier.with({
        --   runtime_condition = function()
        --     local full_name = vim.api.nvim_buf_get_name(0)
        --     return not string.match(full_name, ".*%.text%.erb$")
        --   end,
        -- }),
        nls.builtins.formatting.shellharden,

        -- diagnostics
        -- nls.builtins.diagnostics.erb_lint,
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
        -- nls.builtins.diagnostics.markdownlint,
        nls.builtins.diagnostics.rubocop,

        -- code_actions
        nls.builtins.code_actions.gitsigns,

        -- hover
        nls.builtins.hover.dictionary,
      })
    end,
  },

  -- cmdline tools and lsp servers
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "fixjson",
        -- "prettier",
        -- "rubocop",
        "stylua",
        "shellcheck",
        "shellharden",
        "shfmt",
      })
    end,
  },

  -- TODO:
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
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        lua = { "selene", "luacheck" },
        markdown = { "markdownlint" },
      },
      linters = {
        selene = {
          condition = function(ctx)
            return vim.fs.find({ "selene.toml" }, { path = ctx.filename, upward = true })[1]
          end,
        },
        luacheck = {
          condition = function(ctx)
            return vim.fs.find({ ".luacheckrc" }, { path = ctx.filename, upward = true })[1]
          end,
        },
      },
    },
  },
}
