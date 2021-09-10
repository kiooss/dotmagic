-- require("which-key").setup {
--   icons = {
--     breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
--     separator = "➜", -- symbol used between a key and it's label
--     group = "+" -- symbol prepended to a group
--   }
-- }

-- local wk = require("which-key")

-- wk.register(
--   {
--     f = {
--       name = "+file",
--       t = { "<cmd>NvimTreeToggle<cr>", "NvimTree" },
--       f = { "<cmd>FormatWrite<cr>", "FormatWrite" },
--       -- f = { "<cmd>Telescope find_files<cr>", "Find File" },
--       -- r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File" },
--       -- n = { "<cmd>enew<cr>", "New File" },
--       -- z = "Zoxide",
--       -- d = "Dot Files",
--     },
--     h = {
--       name = "GitSigns" -- optional group name
--     },
--     m = {
--       name = "Coc" -- optional group name
--     }
--   },
--   {prefix = "<leader>"}
-- )

local wk = require("which-key")
local util = require("util")

vim.o.timeoutlen = 300

util.nnoremap("q", ":Sayonara<cr>")
-- util.nnoremap("q", ":Bdelete<cr>")
util.nnoremap("<Tab>", ":wincmd w<cr>")
util.nnoremap("<C-p>", ":NvimTreeToggle<cr>")

wk.setup({show_help = false, triggers = "auto", plugins = {spelling = true}, key_labels = {["<leader>"] = "SPC"}})

local leader = {
  ["W"] = {"<cmd>:VimwikiIndex<cr>", "Wiki"},
  ["w"] = {"<cmd>:update<cr>", "Save"},
  ["x"] = {"<cmd>:x<cr>", "Save and quit"},
  ["z"] = {"<cmd>:qa!<cr>", "Quit all"},
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
  -- c = { v = { "<cmd>Vista!!<CR>", "Vista" }, o = { "<cmd>SymbolsOutline<cr>", "Symbols Outline" } },
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
  g = {
    name = "+git",
    -- g = { "<cmd>Neogit<CR>", "NeoGit" },
    -- l = {
    --   function()
    --     require("util").float_terminal("lazygit")
    --   end,
    --   "LazyGit",
    -- },
    c = {"<Cmd>Telescope git_bcommits<CR>", "buffer commits"},
    b = {"<Cmd>Telescope git_branches<CR>", "branches"},
    s = {"<Cmd>Telescope git_status<CR>", "status"}
    -- d = { "<cmd>DiffviewOpen<cr>", "DiffView" },
    -- h = { name = "+hunk" },
  },
  ["h"] = {
    name = "+gitsigns"
    -- t = {"<cmd>:Telescope builtin<cr>", "Telescope"}
    -- c = { "<cmd>:Telescope commands<cr>", "Commands" },
    -- h = { "<cmd>:Telescope help_tags<cr>", "Help Pages" },
    -- m = { "<cmd>:Telescope man_pages<cr>", "Man Pages" },
    -- k = { "<cmd>:Telescope keymaps<cr>", "Key Maps" },
    -- s = { "<cmd>:Telescope highlights<cr>", "Search Highlight Groups" },
    -- l = { [[<cmd>TSHighlightCapturesUnderCursor<cr>]], "Highlight Groups at cursor" },
    -- f = { "<cmd>:Telescope filetypes<cr>", "File Types" },
    -- o = { "<cmd>:Telescope vim_options<cr>", "Options" },
    -- a = { "<cmd>:Telescope autocommands<cr>", "Auto Commands" },
    -- p = {
    --   name = "+packer",
    --   p = {"<cmd>PackerSync<cr>", "Sync"},
    --   s = {"<cmd>PackerStatus<cr>", "Status"},
    --   i = {"<cmd>PackerInstall<cr>", "Install"},
    --   c = {"<cmd>PackerCompile<cr>", "Compile"}
    -- }
  },
  -- u = { "<cmd>UndotreeToggle<CR>", "Undo Tree" },
  s = {
    name = "+search",
    g = { "<cmd>Telescope live_grep<cr>", "Grep" },
    s = { "<cmd>Telescope current_buffer_fuzzy_find<cr>", "Buffer" },
    l = {
      function()
        require("telescope.builtin").lsp_document_symbols({
          symbols = { "Class", "Function", "Method", "Constructor", "Interface", "Module" },
        })
      end,
      "Goto Symbol",
    },
    h = { "<cmd>Telescope command_history<cr>", "Command History" },
    m = { "<cmd>Telescope marks<cr>", "Jump to Mark" },
    -- r = { "<cmd>lua require('spectre').open()<CR>", "Replace (Spectre)" },
  },
  f = {
    name = "+file",
    d = "Dot Files",
    f = {"<cmd>FormatWrite<cr>", "FormatWrite"},
    t = {"<cmd>NvimTreeFindFile<cr>", "NvimTreeFindFile"},
    w = {"<cmd>Telescope live_grep<cr>", "Search word"},
    r = {"<cmd>Telescope oldfiles<cr>", "Open Recent File"},
    n = {"<cmd>enew<cr>", "New File"},
    m = {"<cmd>Telescope marks<cr>", "Jump to Mark"}
  },
  l = {
    name = "+list",
    t = {"<cmd>:Telescope builtin<cr>", "Telescope"},
    c = {"<cmd>:Telescope commands<cr>", "Commands"},
    h = {"<cmd>:Telescope help_tags<cr>", "Help Pages"},
    m = {"<cmd>:Telescope man_pages<cr>", "Man Pages"},
    k = {"<cmd>:Telescope keymaps<cr>", "Key Maps"},
    s = {"<cmd>:Telescope highlights<cr>", "Search Highlight Groups"},
    l = {[[<cmd>TSHighlightCapturesUnderCursor<cr>]], "Highlight Groups at cursor"},
    f = {"<cmd>:Telescope filetypes<cr>", "File Types"},
    o = {"<cmd>:Telescope vim_options<cr>", "Options"},
    a = {"<cmd>:Telescope autocommands<cr>", "Auto Commands"}
  },
  m = {name = "+coc"},
  -- o = {
  --   name = "+open",
  --   p = { "<cmd>MarkdownPreview<cr>", "Markdown Preview" },
  --   g = { "<cmd>Glow<cr>", "Markdown Glow" },
  -- },
  p = {
    name = "+project",
    p = "Open Project",
    b = {":Telescope file_browser cwd=~/workspace<CR>", "Browse ~/workspace"},
    k = {
      name = "+packer",
      c = {"<cmd>PackerCompile<cr>", "Compile"},
      i = {"<cmd>PackerInstall<cr>", "Install"},
      s = {"<cmd>PackerSync<cr>", "Sync"},
      t = {"<cmd>PackerStatus<cr>", "Status"}
    }
  },
  -- t = {
  --   name = "toggle",
  --   f = {
  --     require("config.lsp.formatting").toggle,
  --     "Format on Save",
  --   },
  --   s = {
  --     function()
  --       util.toggle("spell")
  --     end,
  --     "Spelling",
  --   },
  --   w = {
  --     function()
  --       util.toggle("wrap")
  --     end,
  --     "Word Wrap",
  --   },
  --   n = {
  --     function()
  --       util.toggle("relativenumber", true)
  --       util.toggle("number")
  --     end,
  --     "Line Numbers",
  --   },
  -- },
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
  -- ["`"] = { "<cmd>:e #<cr>", "Switch to Other Buffer" },
  [" "] = "Find File"
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

wk.register(leader, {prefix = "<leader>"})
