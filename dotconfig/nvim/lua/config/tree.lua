vim.g.nvim_tree_ignore = {".git", "node_modules"}
vim.g.nvim_tree_gitignore = 1
vim.g.nvim_tree_auto_open = 1
vim.g.nvim_tree_auto_close = 1
vim.g.nvim_tree_follow = 1
vim.g.nvim_tree_auto_ignore_ft = {"dashboard", "startify"}
vim.g.nvim_tree_git_hl = 1
vim.g.nvim_tree_highlight_opened_files = 3 -- 0 by default, will enable folder and file icon highlight for opened files/directories.
vim.g.nvim_tree_disable_netrw = 1
vim.g.nvim_tree_lsp_diagnostics = 1
vim.g.nvim_tree_hijack_cursor = 1
vim.g.nvim_tree_update_cwd = 1
vim.g.nvim_tree_root_folder_modifier = ':~'
vim.g.nvim_tree_special_files = {README = 1, Makefile = 1, MAKEFILE = 1} -- List of filenames that gets highlighted with NvimTreeSpecialFile
vim.g.nvim_tree_show_icons = {git = 1, folders = 1, files = 1, folder_arrows = 1}

local tree_cb = require "nvim-tree.config".nvim_tree_callback
vim.g.nvim_tree_bindings = {
  {key = "<Tab>", cb = ":wincmd w<cr>"},
  {key = "?", cb = tree_cb("toggle_help")}
}

require("nvim-tree.events").on_nvim_tree_ready(
  function()
    vim.cmd("NvimTreeRefresh")
  end
)
