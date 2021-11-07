local util = require('util')

require('kommentary.config').configure_language('default', { prefer_single_line_comments = true })

require('kommentary.config').configure_language('vue', {
  single_line_comment_string = 'auto',
  multi_line_comment_strings = 'auto',
  hook_function = function()
    require('ts_context_commentstring.internal').update_commentstring()
  end,
})

require('kommentary.config').configure_language('html', {
  single_line_comment_string = 'auto',
  multi_line_comment_strings = 'auto',
  hook_function = function()
    require('ts_context_commentstring.internal').update_commentstring()
  end,
})

require('kommentary.config').configure_language('typescriptreact', {
  single_line_comment_string = 'auto',
  multi_line_comment_strings = 'auto',
  hook_function = function()
    require('ts_context_commentstring.internal').update_commentstring()
  end,
})

util.nmap('<C-_>', '<Plug>kommentary_line_default')
util.vmap('<C-_>', '<Plug>kommentary_visual_default')
