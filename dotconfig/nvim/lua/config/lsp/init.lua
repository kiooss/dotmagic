local util = require("util")
local lspconfig = require("lspconfig")

-- NOTE: https://github.com/neovim/neovim/pull/14681
if vim.lsp.setup then
  vim.lsp.setup({
    floating_preview = {
      border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
    },
    diagnostics = {
      signs = {
        error = " ",
        warning = " ",
        hint = " ",
        information = " ",
      },
      display = {
        underline = true,
        update_in_insert = false,
        virtual_text = { spacing = 4, prefix = "●" },
        severity_sort = true,
      },
    },
    completion = {
      kind = {
        Class = " ",
        Color = " ",
        Constant = " ",
        Constructor = " ",
        Enum = "了 ",
        EnumMember = " ",
        Field = " ",
        File = " ",
        Folder = " ",
        Function = " ",
        Interface = "ﰮ ",
        Keyword = " ",
        Method = "ƒ ",
        Module = " ",
        Property = " ",
        Snippet = "﬌ ",
        Struct = " ",
        Text = " ",
        Unit = " ",
        Value = " ",
        Variable = " ",
      },
    },
  })
else
  -- require("config.lsp.saga")
  require("config.lsp.diagnostics")
  -- require("config.lsp.kind").setup()
end

local function on_attach(client, bufnr)
  require("config.lsp.formatting").setup(client, bufnr)
  require("config.lsp.keys").setup(client, bufnr)
  -- require("config.lsp.completion").setup(client, bufnr)
  require("config.lsp.highlighting").setup(client)

  -- TypeScript specific stuff
  -- TODO: yang
  -- if client.name == "typescript" or client.name == "tsserver" then
  --   require("config.lsp.ts-utils").setup(client)
  -- end
end

local servers = {
  -- pyright = {},
  bashls = {},
  -- dockerls = {},
  -- tsserver = {},
  -- cssls = { cmd = { "css-languageserver", "--stdio" } },
  -- jsonls = { cmd = { "vscode-json-languageserver", "--stdio" } },
  -- html = { cmd = { "html-languageserver", "--stdio" } },
  html = {},
  jsonls = { filetypes = { "json", "jsonc" } },
  cssls = {},
  yamlls = {},
  intelephense = {},
  solargraph = {},
  ["null-ls"] = {},
  sumneko_lua = require("config.lsp.sumneko_lua").config,
  efm = require("config.lsp.efm").config,
  -- vimls = {},
  -- tailwindcss = {},
}

-- nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

-- lua-dev
-- require("lua-dev").setup()

-- null-ls inject non-LSP sources.
require("config.lsp.null-ls").setup()

for server, config in pairs(servers) do
  util.info(server, "Setup LSP")
  lspconfig[server].setup(vim.tbl_deep_extend("force", {
    on_attach = on_attach,
    capabilities = capabilities,
    flags = {
      debounce_text_changes = 150,
    },
  }, config))
  local cfg = lspconfig[server]
  if not (cfg and cfg.cmd and vim.fn.executable(cfg.cmd[1]) == 1) then
    util.error(server .. ": cmd not found: " .. vim.inspect(cfg.cmd))
  end
end
