require("bufferline").setup {
  options = {
    -- mappings = true,
    numbers = function(opts)
      return string.format("%s", opts.raise(opts.ordinal))
    end,
    show_close_icon = false,
    show_buffer_close_icons = false,
    separator_style = "slant",
    diagnostics = "nvim_lsp",
    diagnostics_indicator = function(_, _, diagnostics_dict)
      local s = " "
      for e, n in pairs(diagnostics_dict) do
        local sym = e == "error" and " " or (e == "warning" and " " or "")
        s = s .. sym .. n
      end
      return s
    end,
  }
}

for i = 1, 9 do
  vim.api.nvim_set_keymap("n", "<leader>"..i, [[<Cmd>BufferLineGoToBuffer ]]..i..[[<CR>]], {noremap = true, silent = true})
end
