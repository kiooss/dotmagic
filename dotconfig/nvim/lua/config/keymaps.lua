local util = require("util")

vim.keymap.set("n", "<Tab>", "<cmd>wincmd w<CR>", { desc = "Switch window" })

vim.keymap.del("n", "<leader>w-")
vim.keymap.del("n", "<leader>w|")
vim.keymap.del("n", "<leader>wd")
vim.keymap.del("n", "<leader>ww")
vim.keymap.set("n", "<leader>e", "<cmd>x<CR>", { desc = "Save and Quit" })
vim.keymap.set("n", "<leader>w", "<cmd>update<CR>", { desc = "Save" })
vim.keymap.set("n", "<leader>z", "<cmd>qa!<CR>", { desc = "Quit All!" })
vim.keymap.set("n", "<leader>-", "<cmd>:vsplit<CR>:wincmd p<CR>:e#<CR>", { desc = "Vsplit buffers" })

vim.keymap.set("n", "B", "^")
vim.keymap.set("n", "E", "$")
vim.keymap.set("n", "x", [["_x]]) -- Better x with black hole register "_
vim.keymap.set("n", "Y", "y$")
vim.keymap.set("n", "Q", "q") -- disable Ex mode
vim.keymap.set("n", "g;", "g;zvzz")
vim.keymap.set("n", "g,", "g,zvzz")
vim.keymap.set("n", "<C-o>", "<c-o>zvzz")

vim.keymap.set("i", "jk", "<esc>")
vim.keymap.set("i", "j<space>", "j")
vim.keymap.set("i", "<C-c>", "<esc>`^")

vim.keymap.set("c", "jk", "<C-c>")
vim.keymap.set("c", "j", [[getcmdline()[getcmdpos()-2] ==# 'j' ? "\<BS>\<C-c>" : 'j']], { expr = true })

vim.keymap.set("x", "s", ":s//g<Left><Left>")
vim.keymap.set("x", "<C-l>", [[:s/^/\=(line('.')-line("'<")+1).'. '/g]])

-- run lua
vim.keymap.set("n", "<leader>cR", util.runlua, { desc = "Run Lua" })
