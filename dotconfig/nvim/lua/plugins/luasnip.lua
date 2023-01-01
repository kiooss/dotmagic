-- TODO
local M = {
  'L3MON4D3/LuaSnip',

  dependencies = {
    'rafamadriz/friendly-snippets',
    config = function()
      require('luasnip.loaders.from_vscode').lazy_load()
    end,
  },
}

function M.config()
  local luasnip = require('luasnip')
  require('neogen')

  luasnip.config.setup({
    history = true,
    enable_autosnippets = true,
    -- Update more often, :h events for more info.
    updateevents = 'TextChanged,TextChangedI',
  })

  luasnip.filetype_extend('all', { '_' })
  luasnip.filetype_extend('ruby', { 'rails' })

  require('luasnip.loaders.from_lua').load({ paths = '~/.config/nvim/lua/yy/snippets' })

  -- keymaps
  -- <c-l> is selecting within a list of options.
  -- This is useful for choice nodes (introduced in the forthcoming episode 2)
  vim.keymap.set('i', '<c-l>', function()
    if luasnip.choice_active() then
      luasnip.change_choice(1)
    end
  end)

  vim.keymap.set('i', '<c-u>', require('luasnip.extras.select_choice'))

  vim.keymap.set('n', '<leader>se', function()
    require('luasnip.loaders.from_lua').edit_snippet_files()
  end)
end

return M
