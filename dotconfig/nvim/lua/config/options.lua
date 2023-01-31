local indent = 4
local opt = vim.opt

opt.autoindent = true
opt.autowrite = true -- enable auto write
opt.backupskip = "/tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*,/private/var/*,.vault.vim"
opt.breakat = [[\ \	;:,!?]]
opt.breakindentopt = "shift:2,min:20"
opt.concealcursor = "niv"
opt.conceallevel = 0
opt.cursorline = true -- Enable highlighting of the current line
opt.diffopt = "filler,iwhite,internal,algorithm:patience"
opt.expandtab = true -- Use spaces instead of tabs
opt.fileencodings = "ucs-bom,utf-8,euc-jp,cp932,latin1"
opt.fileformat = "unix"
opt.fileformats = "unix,mac,dos"
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --hidden --vimgrep --smart-case --"
opt.helpheight = 12
opt.hidden = true -- Enable modified buffers in background
opt.history = 2000
opt.ignorecase = true -- ingore case in search patterns.
opt.infercase = true
opt.jumpoptions = "stack"
opt.laststatus = 0
opt.linebreak = true
opt.list = true -- Show some invisible characters (tabs...
opt.matchtime = 2
opt.number = true -- Print line number
opt.previewheight = 12
opt.pumblend = 10 -- Popup blend
opt.pumheight = 10 -- Maximum number of entries in a popup
opt.redrawtime = 1500
opt.relativenumber = true -- Relative line numbers
opt.report = 0 -- Always report changed lines.
opt.scrolloff = 4 -- Lines of context
opt.shada = "!,'300,<50,@100,s10,h"
opt.shiftround = true
opt.shiftround = true -- Round indent
opt.shiftwidth = indent -- Size of an indent
opt.showbreak = "↪ "
opt.showfulltag = true
opt.showmode = false -- dont show mode since we have a statusline
opt.showtabline = 2 -- Always show tabline
opt.sidescrolloff = 8 -- Columns of context
opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
opt.smartcase = true -- Don't ignore case with capitals
opt.smartindent = true -- Insert indents automatically
opt.softtabstop = -1 -- When 'sts' is negative, the value of 'shiftwidth' is used.
opt.splitbelow = true -- Put new windows below current
opt.splitright = true -- Put new windows right of current
opt.swapfile = false
opt.switchbuf = "useopen"
opt.synmaxcol = 2500
opt.tabstop = indent -- Number of spaces tabs count for
opt.termguicolors = true -- True color support
opt.textwidth = 80
opt.ttimeoutlen = 0
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 200 -- save swap file and trigger CursorHold
opt.virtualedit = "block"
opt.wildignorecase = true
opt.winblend = 10 -- Floating window blend
opt.winminwidth = 10
opt.winwidth = 30
opt.wrap = true

vim.o.wildignore =
  ".git,.hg,.svn,*.pyc,*.o,*.out,*.jpg,*.jpeg,*.png,*.gif,*.zip,**/tmp/**,*.DS_Store,**/node_modules/**,**/bower_modules/**"

if vim.fn.has("nvim-0.8") == 1 then
  vim.opt.backup = true
  vim.opt.cmdheight = 0
  vim.opt.backupdir = vim.fn.stdpath("state") .. "/backup"
end

vim.opt.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = " ",
  -- foldsep = " ",
  diff = "╱",
  eob = " ",
}
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.o.foldcolumn = "1"

-- require("util.status")

vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
