local wk = require('which-key')
local util = require('util')

vim.o.timeoutlen = 100

-- util.nnoremap("q", [[len(getbufinfo({'buflisted':1})) > 1 ? ":Sayonara!<cr>" : ":Sayonara<cr>"]], { expr = true })
util.nnoremap('q', ':Sayonara<cr>')
util.nnoremap('<Tab>', ':wincmd w<cr>')
util.nnoremap('<C-p>', ':NvimTreeFindFileToggle<cr>')
-- util.nnoremap('<C-p>', ':NvimTreeToggle<cr>')
-- vsplit buffers
util.nnoremap('<leader>-', ':vsplit<CR>:wincmd p<CR>:e#<CR>')
-- Focus the current fold by closing all others
-- util.nnoremap('<CR>', 'zMza')
-- nnoremap <expr> <CR> {-> v:hlsearch ? ":nohl\<CR>" : "\<CR>"}()
util.nnoremap('<CR>', [[{-> v:hlsearch ? ":nohlsearch\<CR>" : "\<CR>"}()]], { expr = true })
-- util.nnoremap('<ESC><ESC>', ':<C-u>set nopaste nohlsearch<bar>cclose<bar>lclose<bar>pclose<cr>', { silent = true })
util.nnoremap('j', 'gj', { silent = true })
util.nnoremap('k', 'gk', { silent = true })
util.nnoremap('gj', 'j', { silent = true })
util.nnoremap('gk', 'k', { silent = true })
util.nnoremap('g;', 'g;zvzz', { silent = true })
util.nnoremap('g,', 'g,zvzz', { silent = true })
-- Better x with black hole register "_
util.nnoremap('x', [["_x]])
util.nnoremap('Y', 'y$')
util.nnoremap('B', '^')
util.nnoremap('E', '$')
util.nnoremap('g]', 'g<C-]>')
util.nnoremap('g[', ':pop<cr>')

-- disable EX mode
util.nnoremap('Q', 'q')

util.nnoremap('<c-o>', '<c-o>zvzz')

util.inoremap('jk', '<esc>')
util.inoremap('jj', '<esc>')
util.inoremap('j<space>', 'j')
util.inoremap('<C-c>', '<esc>`^')
-- util.inoremap("<C-b>", "<Left>")
-- util.inoremap("<C-f>", "<Right>")
-- util.inoremap("<C-a>", "<C-o>I")
-- util.inoremap("<C-e>", "<C-o>A")
-- util.inoremap("<C-u>", "<C-g>u<C-u>")
util.inoremap('jj', '<esc>')

util.cnoremap('jk', '<C-c>')
util.cnoremap('j', [[getcmdline()[getcmdpos()-2] ==# 'j' ? "\<BS>\<C-c>" : 'j']], { expr = true })
util.cnoremap('<C-a>', '<Home>')
util.cnoremap('<C-b>', '<Left>')
util.cnoremap('<C-f>', '<Right>')
util.cnoremap('<C-d>', '<Del>')
util.cnoremap('<C-e>', '<End>')
util.cnoremap('<C-y>', '<C-r>*')
util.cnoremap('<C-v>', '<C-r>*')
util.cnoremap('<C-g>', '<C-c>')

util.xnoremap('s', ':s//g<Left><Left>')
util.xnoremap('<C-l>', [[:s/^/\=(line('.')-line("'<")+1).'. '/g]])

-- stile select when indent in visual mode
util.vnoremap('<', '<gv')
util.vnoremap('>', '>gv')

-- TODO:
-- noremap <expr> <C-e> (line("w$") >= line('$') ? "j" : "3\<C-e>M")
-- noremap <expr> <C-y> (line("w0") <= 1         ? "k" : "3\<C-y>M")

-- telescope mappings
local telescope_helper = require('config.telescope.helper')

util.nnoremap('/', telescope_helper.curbuf)
util.nnoremap('<leader><space>', telescope_helper.project_files)
util.nnoremap('<leader>ca', telescope_helper.lsp_code_actions)
util.nnoremap('<leader>fd', telescope_helper.dotfiles)
util.nnoremap('<leader>ff', telescope_helper.frecency_files)
util.nnoremap('<leader>fp', telescope_helper.projects)
util.nnoremap('<leader>fr', telescope_helper.oldfiles_cwd_only)
util.nnoremap('<leader>fv', telescope_helper.edit_neovim)
util.nnoremap('<leader>ln', telescope_helper.notify)

wk.setup({
  show_help = false,
  triggers = 'auto',
  plugins = { spelling = true },
  key_labels = { ['<leader>'] = 'SPC', ['<space>'] = 'SPC' },
})

local leader = {
  [' '] = 'Find File',
  ['j'] = { '<cmd>:AnyJump<cr>', 'AnyJump' },
  ['W'] = { '<cmd>:VimwikiIndex<cr>', 'Wiki' },
  ['w'] = { '<cmd>:update<cr>', 'Save' },
  ['x'] = { '<cmd>:x<cr>', 'Save and quit' },
  ['z'] = { '<cmd>:qa!<cr>', 'Quit all' },
  ['`'] = { '<cmd>:e #<cr>', 'Switch to Other Buffer' },
  ['/'] = {
    '<cmd>Telescope live_grep<cr>',
    'Search',
  },
  ['*'] = {
    function()
      require('telescope.builtin').grep_string()
    end,
    'Searches string under cursor',
  },
  -- ["w"] = {
  --   name = "+windows",
  --   ["w"] = {"<C-W>p", "other-window"},
  --   ["d"] = {"<C-W>c", "delete-window"},
  --   ["-"] = {"<C-W>s", "split-window-below"},
  --   ["|"] = {"<C-W>v", "split-window-right"},
  --   ["2"] = {"<C-W>v", "layout-double-columns"},
  --   ["h"] = {"<C-W>h", "window-left"},
  --   ["j"] = {"<C-W>j", "window-below"},
  --   ["l"] = {"<C-W>l", "window-right"},
  --   ["k"] = {"<C-W>k", "window-up"},
  --   ["H"] = {"<C-W>5<", "expand-window-left"},
  --   ["J"] = {":resize +5", "expand-window-below"},
  --   ["L"] = {"<C-W>5>", "expand-window-right"},
  --   ["K"] = {":resize -5", "expand-window-up"},
  --   ["="] = {"<C-W>=", "balance-window"},
  --   ["s"] = {"<C-W>s", "split-window-below"},
  --   ["v"] = {"<C-W>v", "split-window-right"}
  -- },
  -- b = {
  --   name = "+buffer",
  --   ["b"] = { "<cmd>:e #<cr>", "Switch to Other Buffer" },
  --   ["p"] = { "<cmd>:BufferLineCyclePrev<CR>", "Previous Buffer" },
  --   ["["] = { "<cmd>:BufferLineCyclePrev<CR>", "Previous Buffer" },
  --   ["n"] = { "<cmd>:BufferLineCycleNext<CR>", "Next Buffer" },
  --   ["]"] = { "<cmd>:BufferLineCycleNext<CR>", "Next Buffer" },
  --   ["d"] = { "<cmd>:bd<CR>", "Delete Buffer" },
  --   ["g"] = { "<cmd>:BufferLinePick<CR>", "Goto Buffer" },
  -- },
  c = {
    v = { '<cmd>Vista!!<CR>', 'Vista' },
    o = { '<cmd>SymbolsOutline<cr>', 'Symbols Outline' },
  },
  e = {
    name = '+errors',
    e = { '<cmd>TroubleToggle<cr>', 'Trouble' },
    w = { '<cmd>TroubleWorkspaceToggle<cr>', 'Workspace Trouble' },
    d = { '<cmd>TroubleDocumentToggle<cr>', 'Document Trouble' },
    t = { '<cmd>TodoTrouble<cr>', 'Todo Trouble' },
    T = { '<cmd>TodoTelescope<cr>', 'Todo Telescope' },
    l = { '<cmd>lopen<cr>', 'Open Location List' },
    q = { '<cmd>copen<cr>', 'Open Quickfix List' },
  },
  f = {
    name = '+file',
    b = { '<cmd>Telescope file_browser cwd=~/workspace<cr>', 'File browser' },
    d = 'Dot Files',
    f = 'Frecency Files',
    m = { '<cmd>Telescope marks<cr>', 'Jump to Mark' },
    n = { '<cmd>enew<cr>', 'New File' },
    p = 'Open Project',
    r = 'Open Recent Files',
    t = { '<cmd>:Telescope filetypes<cr>', 'File Types' },
    w = { '<cmd>Telescope live_grep<cr>', 'Search word' },
    v = 'Neovim Config',
  },
  g = {
    name = 'git',
    g = { '<cmd>Neogit<CR>', 'NeoGit' },
    l = {
      function()
        require('util').float_terminal('lazygit')
      end,
      'LazyGit',
    },
    a = { '<Cmd>Telescope git_commits<CR>', 'git commits' },
    b = { '<Cmd>Telescope git_branches<CR>', 'git branches' },
    c = { '<Cmd>Telescope git_bcommits<CR>', "buffer's git commits" },
    d = { '<cmd>DiffviewOpen<cr>', 'DiffView' },
    e = { '<cmd>CocCommand git.showCommit<cr>', 'Show Commit' },
    s = { '<Cmd>Telescope git_status<CR>', 'git status' },
    -- h = { name = "+hunk" },
  },
  h = {
    name = '+gitsigns',
    l = { '<cmd>TSHighlightCapturesUnderCursor<cr>', 'Highlight Groups at cursor' },
  },
  -- u = { "<cmd>UndotreeToggle<CR>", "Undo Tree" },
  s = {
    name = 'search',
    g = { '<cmd>Telescope live_grep<cr>', 'Live Grep' },
    h = { '<cmd>Telescope command_history<cr>', 'Command History' },
    m = { '<cmd>Telescope marks<cr>', 'Jump to Mark' },
    r = { "<cmd>lua require('spectre').open()<CR>", 'Replace (Spectre)' },
    s = { '<cmd>Telescope current_buffer_fuzzy_find<cr>', 'Buffer' },
  },
  l = {
    name = 'list',
    a = { '<cmd>:Telescope autocommands<cr>', 'Auto Commands' },
    c = { '<cmd>:Telescope commands<cr>', 'Commands' },
    f = { '<cmd>:Telescope filetypes<cr>', 'File Types' },
    h = { '<cmd>:Telescope help_tags<cr>', 'Help Pages' },
    k = { '<cmd>:Telescope keymaps<cr>', 'Key Maps' },
    m = { '<cmd>:Telescope man_pages<cr>', 'Man Pages' },
    n = 'Notifications',
    o = { '<cmd>:Telescope vim_options<cr>', 'Options' },
    s = { '<cmd>:Telescope highlights<cr>', 'Search Highlight Groups' },
    t = { '<cmd>:Telescope builtin<cr>', 'Telescope Builtins' },
  },
  m = { name = '+coc' },
  -- o = {
  --   name = "+open",
  --   p = { "<cmd>MarkdownPreview<cr>", "Markdown Preview" },
  --   g = { "<cmd>Glow<cr>", "Markdown Glow" },
  -- },
  p = {
    name = 'packer',
    a = { '<cmd>PackerCompile profile=true<cr>', 'PackerCompile (profile)' },
    c = { '<cmd>PackerCompile profile=false<cr>', 'PackerCompile' },
    i = { '<cmd>PackerInstall<cr>', 'PackerInstall' },
    s = { '<cmd>PackerSync<cr>', 'PackerSync' },
    p = { '<cmd>PackerProfile<cr>', 'PackerProfile' },
    t = { '<cmd>PackerStatus<cr>', 'PakcerStatus' },
    x = { '<cmd>PackerClean<cr>', 'PakcerClean' },
  },
  t = {
    name = 'toggle',
    b = {
      function()
        require('gitsigns').toggle_current_line_blame()
      end,
      'Current Line Blame',
    },
    f = {
      require('config.lsp.formatting').toggle,
      'Format on Save',
    },
    i = {
      '<cmd>IndentBlanklineToggle<cr>',
      'IndentLine',
    },
    s = {
      function()
        util.toggle('spell')
      end,
      'Spelling',
    },
    w = {
      function()
        util.toggle('wrap')
      end,
      'Word Wrap',
    },
    n = {
      function()
        util.toggle('relativenumber', true)
        util.toggle('number', true)
        util.toggle('list', true)
        vim.cmd('IndentBlanklineToggle')
      end,
      'Line Numbers + List + IndentLine',
    },
  },
  -- ["<tab>"] = {
  --   name = "workspace",
  --   ["<tab>"] = { "<cmd>tabnew<CR>", "New Tab" },

  --   n = { "<cmd>tabnext<CR>", "Next" },
  --   d = { "<cmd>tabclose<CR>", "Close" },
  --   p = { "<cmd>tabprevious<CR>", "Previous" },
  --   ["]"] = { "<cmd>tabnext<CR>", "Next" },
  --   ["["] = { "<cmd>tabprevious<CR>", "Previous" },
  --   f = { "<cmd>tabfirst<CR>", "First" },
  --   l = { "<cmd>tablast<CR>", "Last" },
  -- },
  -- ["."] = { ":Telescope file_browser<CR>", "Browse Files" },
  -- [","] = { "<cmd>Telescope buffers show_all_buffers=true<cr>", "Switch Buffer" },
  -- ["/"] = { "<cmd>Telescope live_grep<cr>", "Search" },
  -- [":"] = { "<cmd>Telescope command_history<cr>", "Command History" },
  -- q = {
  --   name = "+quit/session",
  --   q = { "<cmd>:qa<cr>", "Quit" },
  --   ["!"] = { "<cmd>:qa!<cr>", "Quit without saving" },
  --   s = { [[<cmd>lua require("persistence").load()<cr>]], "Restore Session" },
  --   l = { [[<cmd>lua require("persistence").load({last=true})<cr>]], "Restore Last Session" },
  --   d = { [[<cmd>lua require("persistence").stop()<cr>]], "Stop Current Session" },
  -- },
  -- x = {
  --   name = "+errors",
  --   x = { "<cmd>TroubleToggle<cr>", "Trouble" },
  --   w = { "<cmd>TroubleWorkspaceToggle<cr>", "Workspace Trouble" },
  --   d = { "<cmd>TroubleDocumentToggle<cr>", "Document Trouble" },
  --   t = { "<cmd>TodoTrouble<cr>", "Todo Trouble" },
  --   T = { "<cmd>TodoTelescope<cr>", "Todo Telescope" },
  --   l = { "<cmd>lopen<cr>", "Open Location List" },
  --   q = { "<cmd>copen<cr>", "Open Quickfix List" },
  -- },
  -- Z = { [[<cmd>lua require("zen-mode").reset()<cr>]], "Zen Mode" },
  -- z = { [[<cmd>ZenMode<cr>]], "Zen Mode" },
  -- T = { [[<Plug>PlenaryTestFile]], "Plenary Test" },
  -- D = {
  --   function()
  --     util.docs()
  --   end,
  --   "Create Docs from README.md",
  -- },
}

for i = 0, 10 do
  leader[tostring(i)] = 'which_key_ignore'
end

wk.register(leader, { prefix = '<leader>' })
