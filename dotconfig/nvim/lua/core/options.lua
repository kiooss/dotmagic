local function bind_option(options)
  for k, v in pairs(options) do
    if v == true then
      vim.cmd('set ' .. k)
    elseif v == false then
      vim.cmd('set no' .. k)
    else
      vim.cmd('set ' .. k .. '=' .. v)
    end
  end
end

local function load_options()
  local global_local = {
    termguicolors = true,
    encoding = 'utf-8',
    fileencoding = 'utf-8',
    fileencodings = 'ucs-bom,utf-8,euc-jp,cp932,latin1',
    mouse = 'a',
    errorbells = true,
    visualbell = true,
    hidden = true,
    fileformat = 'unix',
    fileformats = 'unix,mac,dos',
    magic = true,
    virtualedit = 'block',
    viewoptions = 'folds,cursor,curdir,slash,unix',
    sessionoptions = 'curdir,help,tabpages,winsize',
    clipboard = 'unnamedplus',
    wildmode = 'list:longest,full',
    wildignorecase = true,
    wildignore = '.git,.hg,.svn,*.pyc,*.o,*.out,*.jpg,*.jpeg,*.png,*.gif,*.zip,**/tmp/**,*.DS_Store,**/node_modules/**,**/bower_modules/**',
    backup = false,
    writebackup = false,
    swapfile = false,
    -- TODO
    -- directory = global.cache_dir .. "swag/",
    -- undodir = global.cache_dir .. "undo/",
    -- backupdir = global.cache_dir .. "backup/",
    -- viewdir = global.cache_dir .. "view/",
    -- spellfile = global.cache_dir .. "spell/en.uft-8.add",
    history = 2000,
    -- TODO
    shada = "!,'300,<50,@100,s10,h",
    backupskip = '/tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*,/private/var/*,.vault.vim',
    smarttab = true,
    shiftround = true,
    timeout = true,
    ttimeout = true,
    timeoutlen = 500,
    ttimeoutlen = 0,
    updatetime = 100,
    redrawtime = 1500,
    ignorecase = true,
    smartcase = true,
    infercase = true,
    incsearch = true,
    wrapscan = true,
    complete = '.,w,b,k',
    -- TODO
    -- set complete=.,w,b,u
    inccommand = 'nosplit',
    grepformat = '%f:%l:%c:%m',
    grepprg = 'rg --hidden --vimgrep --smart-case --',
    breakat = [[\ \	;:,!?]],
    startofline = false,
    -- whichwrap = "h,l,<,>,[,],~",
    splitbelow = true,
    splitright = true,
    -- TODO
    -- set switchbuf=useopen,usetab    " Jump to the first open window in any tab
    -- set switchbuf+=vsplit           " Switch buffer behavior to vsplit
    switchbuf = 'useopen',
    backspace = 'indent,eol,start',
    diffopt = 'filler,iwhite,internal,algorithm:patience',
    showfulltag = true,
    -- TODO
    completeopt = 'menuone,noselect',
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
    laststatus = 2,
    display = 'lastline',
    -- showbreak = "↳  ",
    showbreak = '↪ ',
    -- TODO
    -- listchars = "tab:»·,nbsp:+,trail:·,extends:→,precedes:←",
    -- listchars = 'tab:▸ ,trail:•,eol:¬,extends:❯,precedes:❮,nbsp:⦸',
    pumblend = 10,
    winblend = 10,
    autoread = true,
    autowrite = true,
    modeline = true,
    report = 0,
    path = '.,**',
    matchtime = 2,
    title = true,
    titlestring = 'VIM:  %f',
  }

  local bw_local = {
    undofile = true,
    synmaxcol = 2500,
    formatoptions = '1jcroql',
    textwidth = 80,
    expandtab = true,
    autoindent = true,
    smartindent = true,
    tabstop = 4,
    shiftwidth = 4,
    softtabstop = -1, -- When 'sts' is negative, the value of 'shiftwidth' is used.
    breakindentopt = 'shift:2,min:20',
    wrap = true,
    linebreak = true,
    number = true,
    relativenumber = true,
    foldenable = true,
    foldmethod = 'marker',
    foldlevelstart = 99,
    foldnestmax = 10,
    -- foldtext="vimrc#MyFoldText()",
    signcolumn = 'auto:4',
    conceallevel = 0,
    concealcursor = 'niv',
  }

  for name, value in pairs(global_local) do
    vim.o[name] = value
  end
  bind_option(bw_local)
end

load_options()
