-- LazyVim already provides: last cursor position, checktime on focus, resize splits,
-- auto-create parent dirs on save. Only additions / overrides live here.
local group = vim.api.nvim_create_augroup("kiooss", { clear = true })

vim.api.nvim_create_autocmd("VimLeave", {
  command = "wshada!",
  group = group,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*.log",
  command = "normal! G",
  group = group,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  desc = "Strip trailing whitespace, keeping the cursor in place",
  callback = function(ev)
    -- trailing spaces are meaningful there (markdown hard breaks, patch context)
    if vim.bo[ev.buf].binary or vim.tbl_contains({ "markdown", "diff" }, vim.bo[ev.buf].filetype) then
      return
    end
    local view = vim.fn.winsaveview()
    vim.cmd([[keeppatterns %s/\s\+$//e]])
    vim.fn.winrestview(view)
  end,
  group = group,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "/tmp/*", "COMMIT_EDITMSG", "MERGE_MSG", "*.tmp", "*.bak" },
  command = "setlocal noundofile",
  group = group,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  desc = "Per-directory backup extension, so same-named files don't clobber each other in 'backupdir'",
  callback = function(ev)
    if ev.match:match("^%w%w+:[\\/][\\/]") then
      return
    end
    local file = vim.uv.fs_realpath(ev.match) or ev.match
    local ext = vim.fn.fnamemodify(file, ":p:~:h"):gsub("[/\\]", "%%")
    vim.go.backupext = ext
  end,
  group = group,
})

vim.api.nvim_create_autocmd("ColorScheme", {
  desc = "custom highlight",
  callback = function()
    vim.api.nvim_set_hl(0, "MatchParen", { bold = true, reverse = true })
  end,
  group = group,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "dashboard" },
  command = "set showtabline=0 | autocmd WinLeave <buffer> set showtabline=2",
  group = group,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "crontab" },
  command = "setlocal nobackup nowritebackup",
  group = group,
})

-- replace LazyVim's short yank flash with a longer one
pcall(vim.api.nvim_del_augroup_by_name, "lazyvim_highlight_yank")
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "highlight on yank",
  callback = function()
    vim.hl.on_yank({ higroup = "IncSearch", timeout = 1000 })
  end,
  group = group,
})

-- show cursor line only in active window
vim.api.nvim_create_autocmd({ "InsertLeave", "WinEnter" }, {
  callback = function()
    local ok, cl = pcall(vim.api.nvim_win_get_var, 0, "auto-cursorline")
    if ok and cl then
      vim.wo.cursorline = true
      vim.api.nvim_win_del_var(0, "auto-cursorline")
    end
  end,
  group = group,
})
vim.api.nvim_create_autocmd({ "InsertEnter", "WinLeave" }, {
  callback = function()
    local cl = vim.wo.cursorline
    if cl then
      vim.api.nvim_win_set_var(0, "auto-cursorline", cl)
      vim.wo.cursorline = false
    end
  end,
  group = group,
})

vim.filetype.add({
  extension = {
    overlay = "dts",
    keymap = "dts",
    env = "dotenv",
    thor = "ruby",
  },
  -- Detect and apply filetypes based on the entire filename
  filename = {
    [".env"] = "dotenv",
    ["env"] = "dotenv",
    ["tsconfig.json"] = "jsonc",
    ["Thorfile"] = "ruby",
  },
  -- Detect and apply filetypes based on certain patterns of the filenames
  pattern = {
    -- INFO: Match filenames like - ".env.example", ".env.local" and so on
    ["%.env%.[%w_.-]+"] = "dotenv",
    [".*%.blade%.php"] = "blade",
    [os.getenv("HOME") .. "/%.ssh/conf%.d/.*"] = "sshconfig",
  },
})

vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    local commentstrings = {
      dts = "// %s",
      dotenv = "# %s",
    }
    local ft = vim.bo.filetype
    if commentstrings[ft] then
      vim.bo.commentstring = commentstrings[ft]
    end
  end,
  group = group,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.spell = false
  end,
  group = group,
})
