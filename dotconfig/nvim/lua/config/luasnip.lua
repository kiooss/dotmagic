local ls = require('luasnip')

ls.config.set_config({
  history = true,
  -- Update more often, :h events for more info.
  updateevents = 'TextChanged,TextChangedI',
})

-- You can also use lazy loading so snippets are loaded on-demand, not all at once (may interfere with lazy-loading luasnip itself).
require('luasnip.loaders.from_vscode').lazy_load() -- You can pass { paths = "./my-snippets/"} as well

-- You can also use snippets in snipmate format, for example <https://github.com/honza/vim-snippets>.
-- The usage is similar to vscode.

-- One peculiarity of honza/vim-snippets is that the file containing global
-- snippets is _.snippets, so we need to tell luasnip that the filetype "_"
-- contains global snippets:
ls.filetype_extend('all', { '_' })
ls.filetype_extend('ruby', { 'rails' })

-- load luasnip snippets
require('luasnip.loaders.from_lua').load({ paths = '~/.config/nvim/lua/yy/snippets' })

-- keymaps
-- <c-l> is selecting within a list of options.
-- This is useful for choice nodes (introduced in the forthcoming episode 2)
vim.keymap.set('i', '<c-l>', function()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end)

vim.keymap.set('i', '<c-u>', require('luasnip.extras.select_choice'))

vim.keymap.set('n', '<leader>se', function()
  require('luasnip.loaders.from_lua').edit_snippet_files()
end)
