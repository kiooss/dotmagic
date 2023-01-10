vim.keymap.set("n", "<Tab>", "<cmd>wincmd w<CR>", { desc = "Switch window" })

vim.keymap.set("n", "<leader>z", "<cmd>qa!<CR>", { desc = "Quit All!" })
vim.keymap.set("n", "<leader>-", "<cmd>:vsplit<CR>:wincmd p<CR>:e#<CR>", { desc = "Vsplit buffers" })

for i = 1, 9 do
  vim.keymap.set("n", "<leader>" .. i, function()
    require("bufferline").go_to_buffer(i, true)
  end, { desc = "Buffer " .. i, silent = true })
end
