require('bufferline').setup({
  options = {
    modified_icon = '',
    numbers = function(opts)
      return string.format('%s', opts.raise(opts.ordinal))
    end,
    show_close_icon = false,
    show_buffer_close_icons = false,
    -- separator_style = "slant" | "thick" | "thin" | { 'any', 'any' },
    separator_style = 'thin',
    diagnostics = 'nvim_lsp',
    diagnostics_indicator = function(_, _, diagnostics_dict)
      local s = ' '
      local signs = { error = '  ', warning = '  ', hint = '  ', info = '  ' }
      for e, n in pairs(diagnostics_dict) do
        local sym = signs[e] or e
        s = s .. sym .. n
      end
      return s
    end,
    offsets = { { filetype = 'NvimTree', text = ' File Explorer', text_align = 'left' } },
  },
})

for i = 1, 9 do
  vim.api.nvim_set_keymap(
    'n',
    '<leader>' .. i,
    [[<Cmd>BufferLineGoToBuffer ]] .. i .. [[<CR>]],
    { noremap = true, silent = true }
  )
end
