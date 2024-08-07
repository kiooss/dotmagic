local util = require("util")

vim.keymap.set("n", "<Tab>", "<cmd>wincmd w<CR>", { desc = "Switch window" })

-- vim.keymap.del("n", "<leader>w-")
-- vim.keymap.del("n", "<leader>w|")
-- vim.keymap.del("n", "<leader>wd")
-- vim.keymap.del("n", "<leader>ww")
vim.keymap.set("n", "<leader>mx", "<cmd>x<CR>", { desc = "Save and Quit" })
vim.keymap.set("n", "<leader>mm", "<cmd>update<CR>", { desc = "Save" })
vim.keymap.set("n", "<leader>z", "<cmd>qa!<CR>", { desc = "Quit All!" })
vim.keymap.set("n", "<leader>-", "<cmd>:vsplit<CR>:wincmd p<CR>:e#<CR>", { desc = "Vsplit buffers" })

vim.keymap.set("n", "<leader>aa", "<cmd>Glcd<cr>", { desc = "change dir for window to file's git working dir" })
vim.keymap.set("n", "<leader>ab", "<cmd>lcd %:p:h<cr>", { desc = "change dir for window to file's dir" })

vim.keymap.set("n", "B", "^")
vim.keymap.set("n", "E", "$")
vim.keymap.set("n", "x", [["_x]]) -- Better x with black hole register "_
vim.keymap.set("n", "c", [["_c]]) -- Better c with black hole register "_
vim.keymap.set("n", "Y", "y$")
vim.keymap.set("n", "Q", "q") -- disable Ex mode
vim.keymap.set("n", "g;", "g;zvzz")
vim.keymap.set("n", "g,", "g,zvzz")
vim.keymap.set("n", "<C-o>", "<c-o>zvzz")
vim.keymap.set("n", "q", LazyVim.ui.bufremove, { desc = "Delete Buffer" })

vim.keymap.set("i", "jk", "<esc>")
vim.keymap.set("i", "j<space>", "j")
vim.keymap.set("i", "<C-c>", "<esc>`^")

vim.keymap.set("c", "jk", "<C-c>")
vim.keymap.set("c", "j", [[getcmdline()[getcmdpos()-2] ==# 'j' ? "\<BS>\<C-c>" : 'j']], { expr = true })

vim.keymap.set("x", "s", ":s//g<Left><Left>", { silent = false })
vim.keymap.set("x", "<C-l>", [[:s/^/\=(line('.')-line("'<")+1).'. '/g]])

vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- run lua
vim.keymap.set("n", "<leader>cR", util.runlua, { desc = "Run Lua" })

if require("lazyvim.util").has("bufferline.nvim") then
  for i = 1, 9 do
    vim.keymap.set("n", "<leader>" .. i, function()
      require("bufferline").go_to(i, true)
    end, { desc = "Buffer " .. i, silent = true })
  end
end

if vim.lsp.inlay_hint then
  vim.keymap.set("n", "<leader>uh", function()
    if vim.lsp.inlay_hint.is_enabled() then
      vim.lsp.inlay_hint.enable(0, false)
    else
      vim.lsp.inlay_hint.enable(0, true)
    end
  end, { desc = "Toggle Inlay Hints" })
end
