local M = {}
local vim = vim

function M.setup()
  -- local border = {
  --   { '🭽', 'FloatBorder' },
  --   { '▔', 'FloatBorder' },
  --   { '🭾', 'FloatBorder' },
  --   { '▕', 'FloatBorder' },
  --   { '🭿', 'FloatBorder' },
  --   { '▁', 'FloatBorder' },
  --   { '🭼', 'FloatBorder' },
  --   { '▏', 'FloatBorder' },
  -- }

  local border = {
    { '╭', 'FloatBorder' },
    { '─', 'FloatBorder' },
    { '╮', 'FloatBorder' },
    { '│', 'FloatBorder' },
    { '╯', 'FloatBorder' },
    { '─', 'FloatBorder' },
    { '╰', 'FloatBorder' },
    { '│', 'FloatBorder' },
  }

  -- add border
  vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = border })
  vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = border })

  -- vim.cmd([[autocmd ColorScheme * highlight NormalFloat guibg=#1f2335]])
  -- vim.cmd([[autocmd ColorScheme * highlight FloatBorder guifg=white guibg=#1f2335]])
end

return M
