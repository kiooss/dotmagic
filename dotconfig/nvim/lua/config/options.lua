local indent = 4
local opt = vim.opt

opt.backupskip = "/tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*,/private/var/*,.vault.vim"
opt.breakat = [[\ \	;:,!?]]
opt.breakindentopt = "shift:2,min:20"
opt.concealcursor = "niv"
opt.conceallevel = 0
opt.diffopt = "filler,iwhite,internal,algorithm:patience"
opt.fileencodings = "ucs-bom,utf-8,euc-jp,cp932,latin1"
opt.fileformat = "unix"
opt.fileformats = "unix,mac,dos"
opt.grepprg = "rg --hidden --vimgrep --smart-case --"
opt.helpheight = 12
opt.history = 2000
opt.infercase = true
opt.jumpoptions = "stack"
opt.linebreak = true
opt.matchtime = 2
opt.previewheight = 12
opt.redrawtime = 1500
opt.report = 0 -- Always report changed lines.
opt.shada = "!,'300,<50,@100,s10,h"
opt.shiftwidth = indent -- Size of an indent
opt.showbreak = "↪ "
opt.showfulltag = true
opt.showtabline = 2 -- Always show tabline
opt.softtabstop = -1 -- When 'sts' is negative, the value of 'shiftwidth' is used.
opt.swapfile = false
opt.switchbuf = "useopen"
opt.synmaxcol = 2500
opt.tabstop = indent -- Number of spaces tabs count for
opt.textwidth = 80
opt.ttimeoutlen = 0
opt.virtualedit = "block"
opt.wildignorecase = true
opt.winblend = 10 -- Floating window blend
opt.winminwidth = 10 -- Minimum window width
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
