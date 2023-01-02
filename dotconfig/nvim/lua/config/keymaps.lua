---@diagnostic disable: missing-parameter

local wk = require("which-key")
local util = require("util")
local telescope_helper = require("util.telescope.helper")

vim.o.timeoutlen = 300

wk.setup({
  show_help = false,
  triggers = "auto",
  plugins = { spelling = true },
  key_labels = { ["<leader>"] = "SPC", ["<space>"] = "SPC" },
})

-- local id
-- for _, key in ipairs({ "h", "j", "k", "l" }) do
--   local count = 0
--   vim.keymap.set("n", key, function()
--     if count >= 10 then
--       id = vim.notify("Hold it Cowboy!", vim.log.levels.WARN, {
--         icon = "🤠",
--         replace = id,
--         keep = function()
--           return count >= 10
--         end,
--       })
--     else
--       count = count + 1
--       vim.defer_fn(function()
--         count = count - 1
--       end, 5000)
--       return key
--     end
--   end, { expr = true })
-- end

local nmap = function(lhs, rhs, opts)
  vim.keymap.set("n", lhs, rhs, opts)
end

local imap = function(lhs, rhs, opts)
  vim.keymap.set("i", lhs, rhs, opts)
end

local cmap = function(lhs, rhs, opts)
  vim.keymap.set("c", lhs, rhs, opts)
end

local xmap = function(lhs, rhs, opts)
  vim.keymap.set("x", lhs, rhs, opts)
end

local vmap = function(lhs, rhs, opts)
  vim.keymap.set("v", lhs, rhs, opts)
end

nmap("-", ":edit %:h<CR>")

-- nmap("q", [[len(getbufinfo({'buflisted':1})) > 1 ? ":Sayonara!<cr>" : ":Sayonara<cr>"]], { expr = true })
nmap("q", ":Sayonara<cr>")
nmap("<Tab>", ":wincmd w<cr>")
nmap("<C-p>", ":NvimTreeFindFileToggle<cr>")
-- vsplit buffers
-- nmap('<leader>-', ':vsplit<CR>:wincmd p<CR>:e#<CR>')

-- nmap('<leader>bo', ':%bd<bar>e#<bar>bd#<cr>')
-- Focus the current fold by closing all others
-- nmap('<CR>', 'zMza')
nmap("<CR>", [[{-> v:hlsearch ? ":nohlsearch\<CR>" : "\<CR>"}()]], { expr = true })
nmap("j", "gj")
nmap("k", "gk")
nmap("gj", "j")
nmap("gk", "k")
nmap("g;", "g;zvzz")
nmap("g,", "g,zvzz")
-- Better x with black hole register "_
nmap("x", [["_x]])
nmap("Y", "y$")
nmap("B", "^")
nmap("E", "$")
nmap("g]", "g<C-]>")
nmap("g[", ":pop<cr>")

-- disable EX mode
nmap("Q", "q")

nmap("<c-o>", "<c-o>zvzz")

-- insert mode maps
imap("jk", "<esc>")
imap("jj", "<esc>")
imap("j<space>", "j")
imap("<C-c>", "<esc>`^")

cmap("jk", "<C-c>")
cmap("j", [[getcmdline()[getcmdpos()-2] ==# 'j' ? "\<BS>\<C-c>" : 'j']], { expr = true })
cmap("<C-a>", "<Home>")
cmap("<C-b>", "<Left>")
cmap("<C-f>", "<Right>")
cmap("<C-d>", "<Del>")
cmap("<C-e>", "<End>")
cmap("<C-y>", "<C-r>*")
cmap("<C-v>", "<C-r>*")
cmap("<C-g>", "<C-c>")

xmap("s", ":s//g<Left><Left>")
xmap("<C-l>", [[:s/^/\=(line('.')-line("'<")+1).'. '/g]])

-- stile select when indent in visual mode
vmap("<", "<gv")
vmap(">", ">gv")

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

local leader = {
  [" "] = { telescope_helper.project_files, "Find File" },
  ["j"] = { "<cmd>:AnyJump<cr>", "AnyJump" },
  ["W"] = { "<cmd>:VimwikiIndex<cr>", "Wiki" },
  ["w"] = { "<cmd>:update<cr>", "Save" },
  ["x"] = { "<cmd>:x<cr>", "Save and quit" },
  ["z"] = { "<cmd>:qa!<cr>", "Quit all" },
  ["`"] = { "<cmd>:e #<cr>", "Switch to Other Buffer" },
  ["-"] = { "<cmd>:vsplit<CR>:wincmd p<CR>:e#<CR>", "Vsplit buffers" },
  ["/"] = {
    function()
      -- require("telescope.builtin").live_grep()
      require("telescope").extensions.live_grep_args.live_grep_args()
    end,
    "Search",
  },
  ["."] = {
    function()
      require("telescope.builtin").resume()
    end,
    "Resume Telescope",
  },
  ["*"] = {
    function()
      require("telescope.builtin").grep_string()
    end,
    "Searches string under cursor",
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
  a = {
    a = { "<cmd>Glcd<cr>", "change dir for window to file's git working dir" },
    b = { "<cmd>lcd %:p:h<cr>", "change dir for window to file's dir" },
    f = { "<cmd>FormatWrite<CR>", "FormatWrite" },
  },
  b = {
    name = "+buffer",
    ["b"] = { "<cmd>:e #<cr>", "Switch to Other Buffer" },
    ["p"] = { "<cmd>:BufferLineCyclePrev<CR>", "Previous Buffer" },
    ["["] = { "<cmd>:BufferLineCyclePrev<CR>", "Previous Buffer" },
    ["n"] = { "<cmd>:BufferLineCycleNext<CR>", "Next Buffer" },
    ["]"] = { "<cmd>:BufferLineCycleNext<CR>", "Next Buffer" },
    ["g"] = { "<cmd>:BufferLinePick<CR>", "Goto Buffer" },
    ["o"] = { ":%bd<bar>e#<bar>bd#<cr>", "Close Other Buffers" },
  },
  c = {
    name = "+code",
    b = {
      function()
        local src_path = vim.fn.expand("%:p:~")
        local src_noext = vim.fn.expand("%:p:~:r")
        local _flag = "-Wall -Wextra -std=c++11 -O2"
        local cmd = string.format("g++ %s %s -o %s && %s", _flag, src_path, src_noext, src_noext)
        -- require('util').float_terminal(cmd)
        require("toggleterm").exec(cmd, 1, 12)
      end,
      "C++ build and run",
    },
    v = { "<cmd>Vista!!<CR>", "Vista" },
    o = { "<cmd>SymbolsOutline<cr>", "Symbols Outline" },
  },
  e = {
    name = "+errors",
    a = { "<cmd>TroubleToggle<cr>", "Trouble" },
    e = { "<cmd>TroubleToggle document_diagnostics<cr>", "Document Trouble" },
    w = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "Workspace Trouble" },
    t = { "<cmd>TodoTrouble<cr>", "Todo Trouble" },
    T = { "<cmd>TodoTelescope<cr>", "Todo Telescope" },
    l = { "<cmd>lopen<cr>", "Open Location List" },
    q = { "<cmd>copen<cr>", "Open Quickfix List" },
  },
  f = {
    name = "+file / flutter",
    b = { '<cmd>lua require "telescope".extensions.file_browser.file_browser()<cr>', "File browser" },
    d = { telescope_helper.dotfiles, "Dot Files" },
    f = { telescope_helper.frecency_files, "Frecency Files" },
    m = { telescope_helper.marks, "Jump to Mark" },
    n = { "<cmd>enew<cr>", "New File" },
    p = { telescope_helper.projects, "Project" },
    r = { telescope_helper.oldfiles_cwd_only, "Recent Files" },
    u = { telescope_helper.flutter_commands, "Flutter Tools" },
    v = { telescope_helper.edit_neovim, "Neovim Config" },
  },
  g = {
    name = "git",
    g = { "<cmd>Neogit<CR>", "NeoGit" },
    l = {
      function()
        require("util").float_terminal("lazygit")
      end,
      "LazyGit",
    },
    a = { "<Cmd>Telescope git_commits<CR>", "git commits" },
    b = { "<Cmd>Git blame<CR>", "git blame" },
    c = { "<Cmd>Telescope git_bcommits<CR>", "buffer's git commits" },
    d = { "<cmd>DiffviewOpen<cr>", "DiffView" },
    e = { "<cmd>Telescope git_branches<cr>", "git branches" },
    s = { "<Cmd>Telescope git_status<CR>", "git status" },
    h = { name = "+hunk" },
  },
  -- h = {
  --   name = '+gitsigns',
  --   l = { '<cmd>TSHighlightCapturesUnderCursor<cr>', 'Highlight Groups at cursor' },
  --   b = 'blame line',
  --   d = 'diff this',
  --   D = 'diff this ~',
  --   p = 'preview',
  --   R = 'reset buffer',
  --   S = 'stage buffer',
  --   u = 'undo stage hunk',
  -- },
  -- u = { "<cmd>UndotreeToggle<CR>", "Undo Tree" },
  s = {
    name = "search",
    b = { telescope_helper.curbuf, "Current Buffer Fuzzy Search" },
    d = { "<cmd>Telescope diagnostics<cr>", "Search Diagnostics" },
    g = { telescope_helper.live_grep_with_cwd, "Live Grep with CWD" },
    h = { telescope_helper.command_history, "Command History" },
    r = { "<cmd>lua require('spectre').open()<CR>", "Replace (Spectre)" },
    t = { "<cmd>Telescope treesitter<cr>", "Treesitter" },
  },
  l = {
    name = "list",
    a = { telescope_helper.autocommands, "Auto Commands" },
    b = { telescope_helper.colorscheme, "Color Schemes" },
    c = { telescope_helper.commands, "Commands" },
    d = { telescope_helper.highlights, "Search Highlight Groups" },
    f = { telescope_helper.filetypes, "File Types" },
    h = { telescope_helper.help_tags, "Help Pages" },
    k = { telescope_helper.keymaps, "Key Maps" },
    m = { telescope_helper.man_pages, "Man Pages" },
    n = { telescope_helper.notify, "Notifications" },
    o = { telescope_helper.vim_options, "Options" },
    r = { telescope_helper.registers, "Registers" },
    s = { telescope_helper.buffers, "Buffers" },
    t = { telescope_helper.builtin, "Telescope Builtins" },
  },
  -- m = { name = '+coc' },
  -- o = {
  --   name = "+open",
  --   p = { "<cmd>MarkdownPreview<cr>", "Markdown Preview" },
  --   g = { "<cmd>Glow<cr>", "Markdown Glow" },
  -- },
  p = {
    name = "packer",
    a = { "<cmd>PackerCompile profile=true<cr>", "PackerCompile (profile)" },
    c = { "<cmd>PackerCompile profile=false<cr>", "PackerCompile" },
    i = { "<cmd>PackerInstall<cr>", "PackerInstall" },
    s = { "<cmd>PackerSync<cr>", "PackerSync" },
    p = { "<cmd>PackerProfile<cr>", "PackerProfile" },
    t = { "<cmd>PackerStatus<cr>", "PakcerStatus" },
    x = { "<cmd>PackerClean<cr>", "PakcerClean" },
  },
  t = {
    name = "toggle",
    b = {
      function()
        require("gitsigns").toggle_current_line_blame()
      end,
      "Current Line Blame",
    },
    c = {
      function()
        local copilot_enabled = vim.fn["copilot#Enabled"]()
        if copilot_enabled == 1 then
          vim.cmd("Copilot disable")
        else
          vim.cmd("Copilot enable")
        end
      end,
      "Copilot",
    },
    -- d = {
    --   require('config.lsp.diagnostics').toggle,
    --   'Diagnostics',
    -- },
    -- f = {
    --   require('config.lsp.formatting').toggle,
    --   'Format on Save',
    -- },
    i = {
      "<cmd>IndentBlanklineToggle<cr>",
      "IndentLine",
    },
    s = {
      function()
        util.toggle("spell")
      end,
      "Spelling",
    },
    w = {
      function()
        util.toggle("wrap")
      end,
      "Word Wrap",
    },
    n = {
      function()
        util.toggle("relativenumber", true)
        util.toggle("number", true)
        util.toggle("list", true)
        vim.cmd("IndentBlanklineToggle")
      end,
      "Line Numbers + List + IndentLine",
    },
    m = {
      function()
        if vim.o.mouse == "a" then
          vim.cmd([[IndentBlanklineDisable]])
          vim.wo.signcolumn = "no"
          vim.o.mouse = "v"
          vim.wo.relativenumber = false
          vim.wo.number = false
          print("Mouse disabled")
        else
          vim.cmd([[IndentBlanklineEnable]])
          vim.wo.signcolumn = "yes"
          vim.o.mouse = "a"
          vim.wo.relativenumber = true
          vim.wo.number = true
          print("Mouse enabled")
        end
      end,
      "Toggle Mouse",
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
  leader[tostring(i)] = "which_key_ignore"
end

wk.register(leader, { prefix = "<leader>" })
