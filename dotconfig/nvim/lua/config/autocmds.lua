local vim = vim

local function jump_to_last_position()
  local last_curpos = vim.fn.line("'\"")
  local last_line = vim.fn.line("$")
  local ft = vim.api.nvim_get_option_value("filetype", {})
  local in_range = last_curpos >= 1 and last_curpos <= last_line
  local is_valid_filetype = ft ~= "commit" and ft ~= "rebase" and ft ~= "gitcommit"
  if in_range and is_valid_filetype and vim.api.nvim_buf_get_name(0) ~= "" then
    vim.cmd([[ normal! g`" ]])
  end
end

local function should_colorcolumn()
  local filetype_exclude = {
    "alpha",
    "diff",
    "packer",
    "fugitiveblame",
    "undotree",
    "nerdtree",
    "qf",
    "list",
    "dashboard",
    "startify",
    "DiffviewFiles",
  }

  for _, ft in ipairs(filetype_exclude) do
    if ft == vim.bo.filetype then
      return false
    end
  end

  return true
end

-- lua api
local group = vim.api.nvim_create_augroup("kiooss", { clear = true })

-- vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter", "InsertLeave" }, {
--   command = [[if ! &cursorline && &filetype !~# '^\(dashboard\|clap_\)' && ! &pvw | setlocal cursorline | endif]],
--   group = group,
-- })
--
-- vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave", "InsertEnter" }, {
--   command = [[if &cursorline && &filetype !~# '^\(dashboard\|clap_\)' && ! &pvw | setlocal nocursorline | endif]],
--   group = group,
-- })

vim.api.nvim_create_autocmd("BufReadPost", {
  desc = "Jump to last position",
  callback = jump_to_last_position,
  group = group,
})

vim.api.nvim_create_autocmd("VimLeave", {
  command = "wshada!",
  group = group,
})

-- Check if file changed when its window is focus, more eager than 'autoread'
vim.api.nvim_create_autocmd("FocusGained", {
  command = "checktime",
  group = group,
})

vim.api.nvim_create_autocmd("VimResized", {
  desc = "Equalize window dimensions when resizing vim window",
  command = "tabdo wincmd =",
  group = group,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*.log",
  command = "normal! G",
  group = group,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  command = [[%s/\s\+$//e]],
  group = group,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "/tmp/*", "COMMIT_EDITMSG", "MERGE_MSG", "*.tmp", "*.bak" },
  command = "setlocal noundofile",
  group = group,
})

-- vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "VimEnter", "WinEnter" }, {
--   desc = "Highlight on focused window",
--   callback = function()
--     if should_colorcolumn() then
--       vim.cmd([[set winhighlight= | let &l:colorcolumn='+' . join(range(1, 254), ',+')]])
--     end
--   end,
--   group = group,
-- })
--
-- vim.api.nvim_create_autocmd({ "FocusLost", "WinLeave" }, {
--   desc = "Unhighlight on unfocused window",
--   callback = function()
--     if should_colorcolumn() then
--       vim.cmd(
--         [[set winhighlight=CursorLineNr:LineNr,IncSearch:ColorColumn,Normal:ColorColumn,NormalNC:ColorColumn,SignColumn:ColorColumn]]
--       )
--     end
--   end,
--   group = group,
-- })

vim.api.nvim_create_autocmd("ColorScheme", {
  desc = "custom highlight",
  callback = function()
    -- vim.api.nvim_set_hl(0, 'Comment', { bold = true })
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

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "highlight on yank",
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 1000 })
  end,
  group = group,
})

-- vim.api.nvim_create_autocmd("TextYankPost", {
--   command = [[if v:event.operator is 'y' && (v:event.regname is '' || v:event.regname is '+') | execute 'OSCYankRegister "' | endif]],
--   group = group,
-- })

vim.api.nvim_create_autocmd("CursorHold", {
  desc = "Show current line diagnostics",
  callback = function()
    vim.diagnostic.open_float(nil, { scope = "cursor", focusable = false, border = "rounded" })
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
})
vim.api.nvim_create_autocmd({ "InsertEnter", "WinLeave" }, {
  callback = function()
    local cl = vim.wo.cursorline
    if cl then
      vim.api.nvim_win_set_var(0, "auto-cursorline", cl)
      vim.wo.cursorline = false
    end
  end,
})

-- create directories when needed, when saving a file
vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("auto_create_dir", { clear = true }),
  callback = function(event)
    local file = vim.loop.fs_realpath(event.match) or event.match

    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
    local backup = vim.fn.fnamemodify(file, ":p:~:h")
    backup = backup:gsub("[/\\]", "%%")
    vim.go.backupext = backup
  end,
})

vim.api.nvim_create_autocmd("WinLeave", {
  callback = function()
    if vim.bo.ft == "TelescopePrompt" and vim.fn.mode() == "i" then
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "i", false)
    end
  end,
})

vim.filetype.add({
  extension = {
    overlay = "dts",
    keymap = "dts",
    -- conf = "dosini",
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
})
