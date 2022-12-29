local indent = 4

vim.opt.fileencodings = 'ucs-bom,utf-8,euc-jp,cp932,latin1'
vim.o.formatoptions = 'jcroqlnt' -- tcqj
vim.opt.clipboard = 'unnamedplus' -- sync with system clipboard
vim.opt.mouse = 'a' -- enable mouse mode

vim.opt.termguicolors = true -- True color support
vim.opt.autowrite = true -- enable auto write
vim.opt.hidden = true -- Enable modified buffers in background
vim.opt.number = true -- Print line number
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

vim.opt.textwidth = 80
vim.opt.autoindent = true
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.breakindentopt = 'shift:2,min:20'
vim.opt.conceallevel = 0
vim.opt.concealcursor = 'niv'

vim.opt.undofile = true
vim.opt.undolevels = 10000
vim.synmaxcol = 2500

vim.opt.wildmode = 'longest:full,full' -- Command-line completion mode
vim.opt.completeopt = 'menu,menuone,noselect'

vim.opt.foldenable = true
vim.opt.foldmethod = 'marker'
vim.opt.foldlevelstart = 99
vim.opt.foldnestmax = 10

vim.opt.ttimeoutlen = 0

local function load_options()
  local global_local = {
    errorbells = true,
    visualbell = true,
    fileformat = 'unix',
    fileformats = 'unix,mac,dos',
    virtualedit = 'block',
    viewoptions = 'folds,cursor,curdir,slash,unix',
    sessionoptions = 'curdir,help,tabpages,winsize',
    -- wildmode = 'list:longest,full',
    wildignorecase = true,
    wildignore = '.git,.hg,.svn,*.pyc,*.o,*.out,*.jpg,*.jpeg,*.png,*.gif,*.zip,**/tmp/**,*.DS_Store,**/node_modules/**,**/bower_modules/**',
    backup = false,
    writebackup = false,
    swapfile = false,
    history = 2000,
    -- TODO
    shada = "!,'300,<50,@100,s10,h",
    backupskip = '/tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*,/private/var/*,.vault.vim',
    shiftround = true,
    updatetime = 100,
    redrawtime = 1500,
    ignorecase = true,
    infercase = true,
    incsearch = true,
    wrapscan = true,
    complete = '.,w,b,k',
    inccommand = 'nosplit',
    grepformat = '%f:%l:%c:%m',
    grepprg = 'rg --hidden --vimgrep --smart-case --',
    breakat = [[\ \	;:,!?]],
    startofline = false,
    -- whichwrap = "h,l,<,>,[,],~",
    -- TODO
    -- set switchbuf=useopen,usetab    " Jump to the first open window in any tab
    -- set switchbuf+=vsplit           " Switch buffer behavior to vsplit
    switchbuf = 'useopen',
    backspace = 'indent,eol,start',
    diffopt = 'filler,iwhite,internal,algorithm:patience',
    showfulltag = true,
    -- TODO
    -- completeopt = 'menuone,noselect',
    jumpoptions = 'stack',
    showmode = false,
    shortmess = 'aoOTIcF',
    scrolloff = 2,
    sidescrolloff = 5,
    foldlevelstart = 99,
    ruler = true,
    cursorline = true,
    cursorcolumn = false,
    list = true,
    showtabline = 2,
    winwidth = 30,
    winminwidth = 10,
    pumheight = 15,
    helpheight = 12,
    previewheight = 12,
    -- showcmd = false,
    showcmd = true,
    cmdheight = 1,
    cmdwinheight = 5,
    equalalways = false,
    -- laststatus = 3,
    display = 'lastline',
    showbreak = '↪ ',
    pumblend = 10,
    winblend = 10,
    modeline = true,
    report = 0,
    path = '.,**',
    matchtime = 2,
    -- title = true,
    -- titlestring = 'VIM:  %f',
  }

  for name, value in pairs(global_local) do
    vim.o[name] = value
  end
end

load_options()

vim.g.markdown_recommended_style = 0

if vim.fn.has('nvim-0.8') == 1 then
  vim.opt.cmdheight = 0
  vim.opt.backupdir = vim.fn.stdpath('state') .. '/backup'
end

if vim.fn.has('nvim-0.9.0') == 1 then
  vim.opt.splitkeep = 'screen'
  vim.o.shortmess = 'filnxtToOFWIcC'
end
