vim.g.nvim_tree_ignore = { '.git', 'node_modules' }
vim.g.nvim_tree_gitignore = 1
vim.g.nvim_tree_auto_ignore_ft = { 'dashboard', 'startify' }
vim.g.nvim_tree_git_hl = 1
vim.g.nvim_tree_highlight_opened_files = 3 -- 0 by default, will enable folder and file icon highlight for opened files/directories.
vim.g.nvim_tree_special_files = { README = 1, Makefile = 1, MAKEFILE = 1 } -- List of filenames that gets highlighted with NvimTreeSpecialFile
vim.g.nvim_tree_show_icons = {
  git = 1,
  folders = 1,
  files = 1,
  folder_arrows = 1,
}
vim.g.nvim_tree_icons = {
  default = '',
  symlink = '',
  git = {
    unstaged = '✚',
    staged = '✚',
    unmerged = '≠',
    renamed = '≫',
    untracked = '★',
  },
}

require('nvim-tree').setup({
  -- disables netrw completely
  disable_netrw = true,
  diagnostics = {
    enable = true,
  },
  -- hijack the cursor in the tree to put it at the start of the filename
  hijack_cursor = true,
  update_focused_file = {
    enable = true,
  },
  view = {
    mappings = {
      list = {
        { key = 'l', cb = ":lua require'nvim-tree'.on_keypress('edit')<CR>" },
        { key = 's', cb = ":lua require'nvim-tree'.on_keypress('vsplit')<CR>" },
        { key = 'i', cb = ":lua require'nvim-tree'.on_keypress('split')<CR>" },
      },
    },
  },
})

require('nvim-tree.events').on_nvim_tree_ready(function()
  vim.cmd('NvimTreeRefresh')
end)
