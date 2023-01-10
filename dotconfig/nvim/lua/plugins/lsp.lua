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

  -- tools
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        -- "prettierd",
        "stylua",
        "selene",
        "luacheck",
        -- "eslint_d",
        "shellcheck",
        "shfmt",
      },
    },
  },

  -- json schemas
  "b0o/SchemaStore.nvim",

  -- lsp servers
  {
    "neovim/nvim-lspconfig",
    opts = {
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
        jsonls = {
          on_new_config = function(new_config)
            new_config.settings.json.schemas = new_config.settings.json.schemas or {}
            vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
          end,
          settings = {
            json = {
              format = {
                enable = true,
              },
              validate = { enable = true },
            },
          },
        },
        pyright = {},
        rust_analyzer = {
          settings = {
            ["rust-analyzer"] = {
              cargo = { allFeatures = true },
              checkOnSave = {
                command = "clippy",
                extraArgs = { "--no-deps" },
              },
            },
          },
        },
        yamlls = {},
        solargraph = {},
        sumneko_lua = {
          -- cmd = { "/home/folke/projects/lua-language-server/bin/lua-language-server" },
          single_file_support = true,
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
              },
              completion = {
                workspaceWord = true,
                callSnippet = "Both",
              },
              misc = {
                parameters = {
                  "--log-level=trace",
                },
              },
              diagnostics = {
                -- enable = false,
                groupSeverity = {
                  strong = "Warning",
                  strict = "Warning",
                },
                groupFileStatus = {
                  ["ambiguity"] = "Opened",
                  ["await"] = "Opened",
                  ["codestyle"] = "None",
                  ["duplicate"] = "Opened",
                  ["global"] = "Opened",
                  ["luadoc"] = "Opened",
                  ["redefined"] = "Opened",
                  ["strict"] = "Opened",
                  ["strong"] = "Opened",
                  ["type-check"] = "Opened",
                  ["unbalanced"] = "Opened",
                  ["unused"] = "Opened",
                },
                unusedLocalExclude = { "_*" },
              },
              format = {
                enable = false,
                defaultConfig = {
                  indent_style = "space",
                  indent_size = "2",
                  continuation_indent_size = "2",
                },
              },
            },
          },
        },
        vimls = {},
      },
    },
  },

  -- null-ls
  {
    "jose-elias-alvarez/null-ls.nvim",
    config = function()
      local nls = require("null-ls")
      nls.setup({
        debounce = 150,
        default_timeout = 10000,
        save_after_format = false,
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
}
