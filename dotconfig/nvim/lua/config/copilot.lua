local util = require('util')

util.imap('<c-j>', 'copilot#Accept("<CR>")', { expr = true })

vim.g.copilot_no_tab_map = 1
vim.g.copilot_filetypes = {
  spectre_panel = false,
}
