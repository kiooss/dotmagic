local vim = vim
local autocmd = {}

function autocmd.nvim_create_augroups(definitions)
  for group_name, definition in pairs(definitions) do
    vim.api.nvim_command('augroup ' .. group_name)
    vim.api.nvim_command('autocmd!')
    for _, def in ipairs(definition) do
      local command = table.concat(vim.tbl_flatten({ 'autocmd', def }), ' ')
      vim.api.nvim_command(command)
    end
    vim.api.nvim_command('augroup END')
  end
end

function autocmd.load_autocmds()
  local definitions = {
    packer = {
      -- { "BufWritePost", "plugins.lua", "source <afile> | PackerCompile" },
      { 'BufWritePost', 'plugins.lua', 'source <afile>' },
    },
    bufs = {
      -- Reload vim config automatically
      {
        'BufWritePost',
        [[$VIM_PATH/{*.vim,*.yaml,vimrc} nested source $MYVIMRC | redraw]],
      },
      -- Reload Vim script automatically if setlocal autoread
      {
        'BufWritePost,FileWritePost',
        '*.vim',
        [[nested if &l:autoread > 0 | source <afile> | echo 'source ' . bufname('%') | endif]],
      },
      { 'BufWritePre', '/tmp/*', 'setlocal noundofile' },
      { 'BufWritePre', 'COMMIT_EDITMSG', 'setlocal noundofile' },
      { 'BufWritePre', 'MERGE_MSG', 'setlocal noundofile' },
      { 'BufWritePre', '*.tmp', 'setlocal noundofile' },
      { 'BufWritePre', '*.bak', 'setlocal noundofile' },
      { 'BufWritePre', '*', [[%s/\s\+$//e]] },
      -- { "BufWritePre", "*.tsx", "lua vim.api.nvim_command('Format')" },
      -- { "BufWritePre", "*.go", "lua require('internal.golines').golines_format()" },
      { 'BufReadPost', '*.log', 'normal! G' },
      {
        'BufReadPost',
        '*',
        [[if &ft !~ '^git\c' && ! &diff && line("'\"") > 0 && line("'\"") <= line("$") | execute 'normal! g`"zvzz' | endif]],
      },
    },

    wins = {
      -- Highlight current line only on focused window
      {
        'WinEnter,BufEnter,InsertLeave',
        '*',
        [[if ! &cursorline && &filetype !~# '^\(dashboard\|clap_\)' && ! &pvw | setlocal cursorline | endif]],
      },
      {
        'WinLeave,BufLeave,InsertEnter',
        '*',
        [[if &cursorline && &filetype !~# '^\(dashboard\|clap_\)' && ! &pvw | setlocal nocursorline | endif]],
      },
      -- Equalize window dimensions when resizing vim window
      { 'VimResized', '*', [[tabdo wincmd =]] },
      -- Force write shada on leaving nvim
      { 'VimLeave', '*', [[if has('nvim') | wshada! | else | wviminfo! | endif]] },
      -- Check if file changed when its window is focus, more eager than 'autoread'
      { 'FocusGained', '* checktime' },
      {
        'BufEnter,FocusGained,VimEnter,WinEnter',
        '*',
        [[if v:lua.should_colorcolumn() | set winhighlight= | let &l:colorcolumn='+' . join(range(1, 254), ',+') | endif]],
      },
      {
        'FocusLost,WinLeave',
        '*',
        [[if v:lua.should_colorcolumn() | set winhighlight=CursorLineNr:LineNr,IncSearch:ColorColumn,Normal:ColorColumn,NormalNC:ColorColumn,SignColumn:ColorColumn | endif]],
      },
    },

    ft = {
      {
        'FileType',
        'dashboard',
        'set showtabline=0 | autocmd WinLeave <buffer> set showtabline=2',
      },
      { 'FileType', 'crontab', 'setlocal nobackup nowritebackup' },
      { 'FileType', 'apache', 'setlocal commentstring=#\\ %s' },
    },

    custom_highlight = {
      {
        'VimEnter',
        '*',
        [[
          highlight Folded gui=bold,italic
          highlight MatchParen cterm=bold ctermfg=red ctermbg=NONE gui=bold,reverse
          highlight NormalFloat cterm=bold gui=bold
          highlight TablineSel cterm=bold,reverse gui=bold,reverse
        ]],
      },
    },

    yank = {
      {
        'TextYankPost',
        [[* silent! lua vim.highlight.on_yank({higroup="IncSearch", timeout=500})]],
      },
      {
        'TextYankPost',
        '*',
        [[if v:event.operator is 'y' && (v:event.regname is '' || v:event.regname is '+') | execute 'OSCYankReg "' | endif]],
      },
    },

    lsp = {
      { 'CursorHold', '*', [[lua vim.diagnostic.open_float(0, {scope="cursor", focusable=false, border='rounded'})]] },
    },
  }

  autocmd.nvim_create_augroups(definitions)
end

autocmd.load_autocmds()
