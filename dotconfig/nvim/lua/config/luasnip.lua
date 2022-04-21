local luasnip = require('luasnip')

luasnip.config.set_config({
  history = true,
  -- Update more often, :h events for more info.
  updateevents = 'TextChanged,TextChangedI',
})

require('luasnip/loaders/from_vscode').load()

-- <c-l> is selecting within a list of options.
-- This is useful for choice nodes (introduced in the forthcoming episode 2)
vim.keymap.set('i', '<c-l>', function()
  if luasnip.choice_active() then
    luasnip.change_choice(1)
  end
end)

vim.keymap.set('i', '<c-u>', require('luasnip.extras.select_choice'))
