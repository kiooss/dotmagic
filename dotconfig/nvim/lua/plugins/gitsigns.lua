require("gitsigns").setup {
  signs = {
    add = {hl = "GitSignsAdd", text = "", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn"},
    change = {hl = "GitSignsChange", text = "", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn"},
    delete = {hl = "GitSignsDelete", text = "", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn"},
    topdelete = {hl = "GitSignsDelete", text = "‾", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn"},
    changedelete = {hl = "GitSignsChange", text = "", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn"}
  },
  numhl = true, -- Toggle with `:Gitsigns toggle_numhl`
  linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
  word_diff = true -- Toggle with `:Gitsigns toggle_word_diff`
}

vim.api.nvim_set_keymap("n", "<leader>hB", [[<Cmd>Gitsigns toggle_current_line_blame<CR>]], {noremap = true})
