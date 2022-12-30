local indent = 4

vim.opt.fileencodings = 'ucs-bom,utf-8,euc-jp,cp932,latin1'
vim.o.formatoptions = 'jcroqlnt' -- tcqj
vim.opt.clipboard = 'unnamedplus' -- sync with system clipboard
vim.opt.mouse = 'a' -- enable mouse mode
vim.opt.fileformat = 'unix'
vim.opt.fileformats = 'unix,mac,dos'
vim.opt.virtualedit = 'block'
vim.opt.sessionoptions = 'curdir,help,tabpages,winsize'
vim.opt.grepprg = 'rg --hidden --vimgrep --smart-case --'
vim.opt.grepformat = '%f:%l:%c:%m'
vim.opt.switchbuf = 'useopen'

vim.opt.termguicolors = true -- True color support
vim.opt.autowrite = true -- enable auto write
vim.opt.cursorline = true -- Enable highlighting of the current line
vim.opt.hidden = true -- Enable modified buffers in background
vim.opt.number = true -- Print line number
vim.opt.list = true -- Show some invisible characters (tabs...
vim.opt.pumblend = 10 -- Popup blend
vim.opt.pumheight = 10 -- Maximum number of entries in a popup
vim.opt.relativenumber = true -- Relative line numbers
vim.opt.scrolloff = 4 -- Lines of context
vim.opt.shiftround = true -- Round indent
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.shiftwidth = indent -- Size of an indent
vim.opt.tabstop = indent -- Number of spaces tabs count for
vim.opt.softtabstop = -1 -- When 'sts' is negative, the value of 'shiftwidth' is used.
vim.opt.laststatus = 0
vim.opt.showmode = false -- dont show mode since we have a statusline
vim.opt.sidescrolloff = 8 -- Columns of context
vim.opt.signcolumn = 'yes' -- Always show the signcolumn, otherwise it would shift the text each time
vim.opt.smartcase = true -- Don't ignore case with capitals
vim.opt.smartindent = true -- Insert indents automatically
vim.opt.splitbelow = true -- Put new windows below current
vim.opt.splitright = true -- Put new windows right of current
vim.opt.wildignorecase = true
vim.opt.shiftround = true
vim.opt.updatetime = 200 -- save swap file and trigger CursorHold
vim.opt.redrawtime = 1500
vim.opt.ignorecase = true -- ingore case in search patterns.
vim.opt.infercase = true
vim.opt.showfulltag = true

vim.opt.textwidth = 80
vim.opt.autoindent = true
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.breakindentopt = 'shift:2,min:20'
vim.opt.conceallevel = 0
vim.opt.concealcursor = 'niv'

vim.opt.backup = true
vim.opt.swapfile = false
vim.opt.history = 2000

vim.opt.undofile = true
vim.opt.undolevels = 10000
vim.opt.synmaxcol = 2500

vim.opt.wildmode = 'longest:full,full' -- Command-line completion mode
vim.opt.completeopt = 'menu,menuone,noselect'

vim.opt.foldenable = true
vim.opt.foldmethod = 'marker'
vim.opt.foldlevelstart = 99
vim.opt.foldnestmax = 10

vim.opt.ttimeoutlen = 0

vim.opt.errorbells = true
vim.opt.visualbell = true
vim.opt.equalalways = false

vim.opt.pumblend = 10 -- Popup blend
vim.opt.winblend = 10 -- Floating window blend
vim.opt.scrolloff = 4 -- Lines of context
vim.opt.sidescrolloff = 8 -- Columns of context
vim.opt.showtabline = 2 -- Always show tabline
vim.opt.pumheight = 15 -- Maximum number of entries in a popup
vim.opt.helpheight = 12
vim.opt.previewheight = 12
vim.opt.winwidth = 30
vim.opt.winminwidth = 10
vim.opt.report = 0 -- Always report changed lines.
vim.opt.matchtime = 2
vim.opt.showbreak = '↪ '
vim.opt.jumpoptions = 'stack'
vim.opt.shada = "!,'300,<50,@100,s10,h"
vim.opt.backupskip = '/tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*,/private/var/*,.vault.vim'
vim.opt.breakat = [[\ \	;:,!?]]
vim.opt.complete = '.,w,b,k'
vim.opt.diffopt = 'filler,iwhite,internal,algorithm:patience'
vim.opt.shortmess = 'aoOTIcF'
-- vim.opt.path = '.,**'

vim.o.wildignore =
  '.git,.hg,.svn,*.pyc,*.o,*.out,*.jpg,*.jpeg,*.png,*.gif,*.zip,**/tmp/**,*.DS_Store,**/node_modules/**,**/bower_modules/**'

vim.g.markdown_recommended_style = 0

if vim.fn.has('nvim-0.8') == 1 then
  vim.opt.cmdheight = 0
  vim.opt.backupdir = vim.fn.stdpath('state') .. '/backup'
end

if vim.fn.has('nvim-0.9.0') == 1 then
  vim.opt.splitkeep = 'screen'
  vim.o.shortmess = 'filnxtToOFWIcC'
end
