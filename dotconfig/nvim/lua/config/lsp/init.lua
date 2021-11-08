-- lsp install:
-- npm i -g pyright
-- npm i -g bash-language-server vscode-langservers-extracted vls yaml-language-server
-- npm i -g typescript typescript-language-server
-- gem install solargraph
-- https://github.com/sumneko/lua-language-server/wiki/Build-and-Run-(Standalone)

-- local lspconfig = require('lspconfig')
-- local vim = vim

require('config.lsp.diagnostics')
-- require("config.lsp.kind").setup()

local function on_attach(client, bufnr)
  require('config.lsp.formatting').setup(client, bufnr)
  require('config.lsp.keys').setup(client, bufnr)
  -- require("config.lsp.completion").setup(client, bufnr)
  require('config.lsp.highlighting').setup(client)
  require('config.lsp.ui').setup()

  -- TypeScript specific stuff
  if client.name == 'typescript' or client.name == 'tsserver' then
    require('config.lsp.ts-utils').setup(client)
  end
end

local servers = {
  pyright = {},
  bashls = {},
  dockerls = {},
  tsserver = {},
  html = {},
  jsonls = require('config.lsp.jsonls').config,
  cssls = {},
  eslint = {},
  yamlls = {},
  intelephense = require('config.lsp.intelephense').config,
  solargraph = { cmd = { 'solargraph', 'stdio' } },
  sumneko_lua = require('config.lsp.sumneko_lua').config,
  -- efm = require("config.lsp.efm").config,
  vuels = require('config.lsp.vuels').config,
  -- vimls = {},
  -- tailwindcss = {},
}

-- nvim-cmp
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

-- lua-dev
-- require("lua-dev").setup()

local options = {
  on_attach = on_attach,
  capabilities = capabilities,
  flags = {
    debounce_text_changes = 150,
  },
}
require('config.lsp.null-ls').setup(options)
require('config.lsp.install').setup(servers, options)

-- for server, config in pairs(servers) do
--   lspconfig[server].setup(vim.tbl_deep_extend('force', {
--     on_attach = on_attach,
--     capabilities = capabilities,
--     flags = {
--       debounce_text_changes = 150,
--     },
--   }, config))
--   local cfg = lspconfig[server]
--   if not (cfg and cfg.cmd and vim.fn.executable(cfg.cmd[1]) == 1) then
--     vim.notify(server .. ': cmd not found: ' .. vim.inspect(cfg.cmd), 'error', {
--       title = 'LSP',
--     })
--   end
-- end
