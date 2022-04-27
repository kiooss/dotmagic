local wk = require('which-key')
local util = require('util')
local telescope_helper = require('config.telescope.helper')

vim.o.timeoutlen = 500

wk.setup({
  show_help = false,
  triggers = 'auto',
  plugins = { spelling = true },
  key_labels = { ['<leader>'] = 'SPC', ['<space>'] = 'SPC' },
})

local leader = {
  [' '] = { telescope_helper.project_files, 'Find File' },
  ['j'] = { '<cmd>:AnyJump<cr>', 'AnyJump' },
  ['W'] = { '<cmd>:VimwikiIndex<cr>', 'Wiki' },
  ['w'] = { '<cmd>:update<cr>', 'Save' },
  ['x'] = { '<cmd>:x<cr>', 'Save and quit' },
  ['z'] = { '<cmd>:qa!<cr>', 'Quit all' },
  ['`'] = { '<cmd>:e #<cr>', 'Switch to Other Buffer' },
  ['/'] = {
    function()
      require('telescope.builtin').live_grep()
    end,
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
  a = {
    a = { '<cmd>Glcd<cr>', "change dir for window to file's git working dir" },
    b = { '<cmd>lcd %:p:h<cr>', "change dir for window to file's dir" },
    f = { '<cmd>FormatWrite<CR>', 'FormatWrite' },
  },
  c = {
    name = '+code',
    b = {
      function()
        local src_path = vim.fn.expand('%:p:~')
        local src_noext = vim.fn.expand('%:p:~:r')
        local _flag = '-Wall -Wextra -std=c++11 -O2'
        local cmd = string.format('g++ %s %s -o %s && %s', _flag, src_path, src_noext, src_noext)
        -- require('util').float_terminal(cmd)
        require('toggleterm').exec(cmd, 1, 12)
      end,
      'C++ build and run',
    },
    v = { '<cmd>Vista!!<CR>', 'Vista' },
    o = { '<cmd>SymbolsOutline<cr>', 'Symbols Outline' },
  },
  e = {
    name = '+errors',
    a = { '<cmd>TroubleToggle<cr>', 'Trouble' },
    e = { '<cmd>TroubleToggle document_diagnostics<cr>', 'Document Trouble' },
    w = { '<cmd>TroubleToggle workspace_diagnostics<cr>', 'Workspace Trouble' },
    t = { '<cmd>TodoTrouble<cr>', 'Todo Trouble' },
    T = { '<cmd>TodoTelescope<cr>', 'Todo Telescope' },
    l = { '<cmd>lopen<cr>', 'Open Location List' },
    q = { '<cmd>copen<cr>', 'Open Quickfix List' },
  },
  f = {
    name = '+file / flutter',
    b = { '<cmd>lua require "telescope".extensions.file_browser.file_browser()<cr>', 'File browser' },
    d = { telescope_helper.dotfiles, 'Dot Files' },
    f = { telescope_helper.frecency_files, 'Frecency Files' },
    m = { telescope_helper.marks, 'Jump to Mark' },
    n = { '<cmd>enew<cr>', 'New File' },
    p = { telescope_helper.projects, 'Project' },
    r = { telescope_helper.oldfiles_cwd_only, 'Recent Files' },
    u = { telescope_helper.flutter_commands, 'Flutter Tools' },
    v = { telescope_helper.edit_neovim, 'Neovim Config' },
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
    b = { '<Cmd>Git blame<CR>', 'git blame' },
    c = { '<Cmd>Telescope git_bcommits<CR>', "buffer's git commits" },
    d = { '<cmd>DiffviewOpen<cr>', 'DiffView' },
    e = { '<cmd>Telescope git_branches<cr>', 'git branches' },
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
    b = { telescope_helper.curbuf, 'Current Buffer Fuzzy Search' },
    g = { telescope_helper.live_grep_with_cwd, 'Live Grep with CWD' },
    h = { telescope_helper.command_history, 'Command History' },
    r = { "<cmd>lua require('spectre').open()<CR>", 'Replace (Spectre)' },
    t = { '<cmd>Telescope treesitter<cr>', 'Treesitter' },
  },
  l = {
    name = 'list',
    a = { telescope_helper.autocommands, 'Auto Commands' },
    b = { telescope_helper.colorscheme, 'Color Schemes' },
    c = { telescope_helper.commands, 'Commands' },
    f = { telescope_helper.filetypes, 'File Types' },
    h = { telescope_helper.help_tags, 'Help Pages' },
    k = { telescope_helper.keymaps, 'Key Maps' },
    m = { telescope_helper.man_pages, 'Man Pages' },
    n = { telescope_helper.notify, 'Notifications' },
    o = { telescope_helper.vim_options, 'Options' },
    r = { telescope_helper.registers, 'Registers' },
    s = { telescope_helper.highlights, 'Search Highlight Groups' },
    t = { telescope_helper.builtin, 'Telescope Builtins' },
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
    c = {
      function()
        local copilot_enabled = vim.fn['copilot#Enabled']()
        if copilot_enabled == 1 then
          vim.cmd('Copilot disable')
        else
          vim.cmd('Copilot enable')
        end
      end,
      'Copilot',
    },
    d = {
      require('config.lsp.diagnostics').toggle,
      'Diagnostics',
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
    m = {
      function()
        if vim.o.mouse == 'a' then
          vim.cmd([[IndentBlanklineDisable]])
          vim.wo.signcolumn = 'no'
          vim.o.mouse = 'v'
          vim.wo.relativenumber = false
          vim.wo.number = false
          print('Mouse disabled')
        else
          vim.cmd([[IndentBlanklineEnable]])
          vim.wo.signcolumn = 'yes'
          vim.o.mouse = 'a'
          vim.wo.relativenumber = true
          vim.wo.number = true
          print('Mouse enabled')
        end
      end,
      'Toggle Mouse',
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
