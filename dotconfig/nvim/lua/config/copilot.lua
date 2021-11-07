local util = require('util')

util.imap('<c-k>', 'copilot#Accept("<CR>")', { expr = true })

vim.g.copilot_no_tab_map = 1
