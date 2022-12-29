require('neogen').setup({
  snippet_engine = 'luasnip',
})

vim.keymap.set('n', '<leader>n', function()
  require('neogen').generate()
end, { desc = 'neogen' })
