local nmap = function(lhs, rhs, opts)
  vim.keymap.set('n', lhs, rhs, opts)
end

local imap = function(lhs, rhs, opts)
  vim.keymap.set('i', lhs, rhs, opts)
end

local cmap = function(lhs, rhs, opts)
  vim.keymap.set('c', lhs, rhs, opts)
end

local xmap = function(lhs, rhs, opts)
  vim.keymap.set('x', lhs, rhs, opts)
end

local vmap = function(lhs, rhs, opts)
  vim.keymap.set('v', lhs, rhs, opts)
end

nmap('-', ':edit %:h<CR>')

-- nmap("q", [[len(getbufinfo({'buflisted':1})) > 1 ? ":Sayonara!<cr>" : ":Sayonara<cr>"]], { expr = true })
nmap('q', ':Sayonara<cr>')
nmap('<Tab>', ':wincmd w<cr>')
nmap('<C-p>', ':NvimTreeFindFileToggle<cr>')
-- vsplit buffers
nmap('<leader>-', ':vsplit<CR>:wincmd p<CR>:e#<CR>')

nmap('<leader>bo', ':%bd<bar>e#<bar>bd#<cr>')
-- Focus the current fold by closing all others
-- nmap('<CR>', 'zMza')
nmap('<CR>', [[{-> v:hlsearch ? ":nohlsearch\<CR>" : "\<CR>"}()]], { expr = true })
nmap('j', 'gj')
nmap('k', 'gk')
nmap('gj', 'j')
nmap('gk', 'k')
nmap('g;', 'g;zvzz')
nmap('g,', 'g,zvzz')
-- Better x with black hole register "_
nmap('x', [["_x]])
nmap('Y', 'y$')
nmap('B', '^')
nmap('E', '$')
nmap('g]', 'g<C-]>')
nmap('g[', ':pop<cr>')

-- disable EX mode
nmap('Q', 'q')

nmap('<c-o>', '<c-o>zvzz')

-- insert mode maps
imap('jk', '<esc>')
imap('jj', '<esc>')
imap('j<space>', 'j')
imap('<C-c>', '<esc>`^')

cmap('jk', '<C-c>')
cmap('j', [[getcmdline()[getcmdpos()-2] ==# 'j' ? "\<BS>\<C-c>" : 'j']], { expr = true })
cmap('<C-a>', '<Home>')
cmap('<C-b>', '<Left>')
cmap('<C-f>', '<Right>')
cmap('<C-d>', '<Del>')
cmap('<C-e>', '<End>')
cmap('<C-y>', '<C-r>*')
cmap('<C-v>', '<C-r>*')
cmap('<C-g>', '<C-c>')

xmap('s', ':s//g<Left><Left>')
xmap('<C-l>', [[:s/^/\=(line('.')-line("'<")+1).'. '/g]])

-- stile select when indent in visual mode
vmap('<', '<gv')
vmap('>', '>gv')

-- telescope mappings
-- local telescope_helper = require('config.telescope.helper')

-- util.nnoremap('/', telescope_helper.curbuf)
-- nmap('<leader><space>', telescope_helper.project_files)
-- nmap('<leader>fd', telescope_helper.dotfiles)
-- nmap('<leader>ff', telescope_helper.frecency_files)
-- nmap('<leader>fp', telescope_helper.projects)
-- nmap('<leader>fr', telescope_helper.oldfiles_cwd_only)
-- nmap('<leader>fv', telescope_helper.edit_neovim)
-- nmap('<leader>ln', telescope_helper.notify)
-- nmap('<leader>fu', telescope_helper.flutter_commands)
