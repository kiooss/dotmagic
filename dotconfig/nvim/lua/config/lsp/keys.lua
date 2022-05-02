local wk = require('which-key')
local telescope_helper = require('config.telescope.helper')

local M = {}

function M.setup(client, bufnr)
  -- Mappings.
  local opts = { noremap = true, silent = true, buffer = bufnr }

  local keymap = {
    c = {
      r = { '<cmd>lua vim.lsp.buf.rename()<CR>', 'Rename' },
      a = { '<cmd>lua vim.lsp.buf.code_action()<CR>', 'Code Action' },
      l = {
        name = '+lsp',
        i = { '<cmd>LspInfo<cr>', 'Lsp Info' },
        a = { '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', 'Add Workspace Folder' },
        -- e = { "<cmd>lua vim.cmd('e'..vim.lsp.get_log_path())<CR>", 'Open LSP Debug log' },
        e = {
          function()
            require('util').float_terminal('tail -f ' .. vim.lsp.get_log_path())
          end,
          'Open LSP Debug log',
        },
        r = {
          '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>',
          'Remove Workspace Folder',
        },
        l = {
          '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>',
          'List Workspace Folders',
        },
        h = {
          function()
            require('util').lsp_config()
          end,
          'Lsp Config',
        },
      },
    },
    e = {
      s = {
        function()
          require('telescope.builtin').diagnostics({ bufnr = 0 })
        end,
        'Diagnostics',
      },
    },
    s = {
      s = { telescope_helper.lsp_document_symbols, 'LSP document symbols' },
      w = { telescope_helper.lsp_workspace_symbols, 'LSP workspace symbols' },
    },
  }

  if client.name == 'typescript' then
    keymap.c.o = { '<cmd>:TSLspOrganize<CR>', 'Organize Imports' }
    keymap.c.R = { '<cmd>:TSLspRenameFile<CR>', 'Rename File' }
  end

  local keymap_visual = {
    c = {
      name = '+code',
      a = { ':<C-U>lua vim.lsp.buf.range_code_action()<CR>', 'Code Action' },
    },
  }

  local keymap_goto = {
    name = '+goto',
    r = {
      telescope_helper.lsp_references,
      'References',
    },
    R = { '<cmd>Trouble lsp_references<cr>', 'Trouble References' },
    -- d = { '<Cmd>lua vim.lsp.buf.definition()<CR>', 'Goto Definition' },
    d = { telescope_helper.lsp_definitions, 'Goto Definition' },
    D = { '<Cmd>lua vim.lsp.buf.declaration()<CR>', 'Goto Declaration' },
    -- dv = { "<Cmd>vsplit | lua vim.lsp.buf.definition()<CR>", "Goto Definition" },
    -- ds = { "<Cmd>split | lua vim.lsp.buf.definition()<CR>", "Goto Definition" },
    h = { '<cmd>lua vim.lsp.buf.signature_help()<CR>', 'Signature Help' },
    -- I = { '<cmd>lua vim.lsp.buf.implementation()<CR>', 'Goto Implementation' },
    I = { require('telescope.builtin').lsp_implementations, 'Goto Implementation' },
    -- t = { '<cmd>lua vim.lsp.buf.type_definition()<CR>', 'Goto Type Definition' },
    t = { require('telescope.builtin').lsp_type_definitions, 'Goto Type Definition' },
  }

  vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.keymap.set('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  vim.keymap.set('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  vim.keymap.set('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)

  -- local trigger_chars = client.resolved_capabilities.signature_help_trigger_characters
  local trigger_chars = { ',' }
  for _, c in ipairs(trigger_chars) do
    vim.keymap.set('i', c, function()
      vim.defer_fn(function()
        pcall(vim.lsp.buf.signature_help)
      end, 0)
      return c
    end, {
      noremap = true,
      silent = true,
      buffer = bufnr,
      expr = true,
    })
  end

  if client.supports_method('textDocument/formatting') then
    keymap.c.f = { '<cmd>lua vim.lsp.buf.formatting()<CR>', 'Format Document' }
  elseif client.supports_method('textDocument/rangeFormatting') then
    keymap_visual.c.f = {
      '<cmd>lua vim.lsp.buf.range_formatting()<CR>',
      'Format Range',
    }
  end

  wk.register(keymap, { buffer = bufnr, prefix = '<leader>' })
  wk.register(keymap_visual, { buffer = bufnr, prefix = '<leader>', mode = 'v' })
  wk.register(keymap_goto, { buffer = bufnr, prefix = 'g' })
end

return M
