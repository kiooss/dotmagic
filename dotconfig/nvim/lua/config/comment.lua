require('Comment').setup({
  -- ignores empty lines
  ignore = '^$',
})

local ft = require('Comment.ft')

ft({ 'go', 'rust', 'dart' }, { '//%s', '/*%s*/' })
