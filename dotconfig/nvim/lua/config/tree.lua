vim.g.nvim_tree_auto_ignore_ft = { 'dashboard', 'startify' }
vim.g.nvim_tree_git_hl = 1
vim.g.nvim_tree_highlight_opened_files = 3 -- 0 by default, will enable folder and file icon highlight for opened files/directories.
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
    unstaged = '',
    staged = '✓',
    unmerged = '≠',
    renamed = '≫',
    untracked = '★',
    deleted = '',
  },
}
vim.g.nvim_tree_special_files = {
  README = true,
  Makefile = true,
  MAKEFILE = true,
  ['README.md'] = true,
  ['readme.md'] = true,
}

require('nvim-tree').setup({
  -- disables netrw completely
  disable_netrw = true,
  hijack_netrw = true,
  diagnostics = {
    enable = true,
    show_on_dirs = true,
    icons = {
      hint = '',
      info = '',
      warning = '',
      error = '',
    },
  },
  -- hijack the cursor in the tree to put it at the start of the filename
  hijack_cursor = true,
  hijack_directories = {
    enable = true,
    auto_open = true,
  },
  update_cwd = true,
  update_focused_file = {
    enable = true,
  },
  git = {
    enable = true,
    ignore = true,
    timeout = 500,
  },
  view = {
    mappings = {
      list = {
        { key = '<tab>', cb = ':wincmd w<CR>' },
        { key = 'l', cb = ":lua require'nvim-tree'.on_keypress('edit')<CR>" },
        { key = 's', cb = ":lua require'nvim-tree'.on_keypress('vsplit')<CR>" },
        { key = 'i', cb = ":lua require'nvim-tree'.on_keypress('split')<CR>" },
      },
    },
  },
  actions = {
    open_file = {
      resize_window = true,
    },
  },
})
