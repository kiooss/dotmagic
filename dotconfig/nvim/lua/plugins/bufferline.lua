local M = {
  'akinsho/nvim-bufferline.lua',
  event = 'BufAdd',
}

function M.config()
  local signs = require('plugins.lsp.diagnostics').signs

  signs = {
    error = signs.Error,
    warning = signs.Warn,
    info = signs.Info,
    hint = signs.Hint,
  }

  local severities = {
    'error',
    'warning',
    -- "info",
    -- "hint",
  }

  require('bufferline').setup({
    options = {
      modified_icon = '',
      numbers = function(opts)
        return string.format('%s', opts.raise(opts.ordinal))
      end,
      show_close_icon = false,
      diagnostics = 'nvim_lsp',
      separator_style = 'thin',
      diagnostics_indicator = function(_, _, diag)
        local s = {}
        for _, severity in ipairs(severities) do
          if diag[severity] then
            table.insert(s, signs[severity] .. diag[severity])
          end
        end
        return table.concat(s, ' ')
      end,
      offsets = { { filetype = 'NvimTree', text = ' File Explorer', text_align = 'left' } },
    },
  })
end

function M.init()
  --   vim.keymap.set("n", "<leader>bp", "<cmd>:BufferLineCyclePrev<CR>", { desc = "Previous Buffer" })
  --   vim.keymap.set("n", "<leader>bn", "<cmd>:BufferLineCycleNext<CR>", { desc = "Next Buffer" })
  --   vim.keymap.set("n", "[b", "<cmd>:BufferLineCyclePrev<CR>", { desc = "Previous Buffer" })
  --   vim.keymap.set("n", "]b", "<cmd>:BufferLineCycleNext<CR>", { desc = "Next Buffer" })
  for i = 1, 9 do
    vim.keymap.set('n', '<leader>' .. i, [[<Cmd>BufferLineGoToBuffer ]] .. i .. [[<CR>]], { desc = 'Goto Buffer' .. i })
  end
end

return M
