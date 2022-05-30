vim.g.nvim_tree_auto_ignore_ft = { 'dashboard', 'startify' }

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
  renderer = {
    highlight_git = true,
    highlight_opened_files = 'all',
  },
})
