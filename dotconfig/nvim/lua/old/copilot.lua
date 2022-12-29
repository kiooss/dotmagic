vim.g.copilot_no_tab_map = 1
vim.g.copilot_filetypes = {
  spectre_panel = false,
}

vim.keymap.set('i', '<c-j>', 'copilot#Accept("<CR>")', { expr = true })
