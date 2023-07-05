local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", lazypath })
  vim.fn.system({ "git", "-C", lazypath, "checkout", "tags/stable" }) -- last stable release
end
vim.opt.rtp:prepend(lazypath)

---@param opts LazyConfig
return function(opts)
  opts = vim.tbl_deep_extend("force", {
    spec = {
      {
        "LazyVim/LazyVim",
        import = "lazyvim.plugins",
        opts = {},
      },
      { import = "lazyvim.plugins.extras.lang.typescript" },
      -- { import = "lazyvim.plugins.extras.linting.eslint" },
      -- { import = "lazyvim.plugins.extras.formatting.prettier" },
      -- { import = "lazyvim.plugins.extras.coding.copilot" },
      { import = "lazyvim.plugins.extras.lang.json" },
      { import = "lazyvim.plugins.extras.lang.tailwind" },
      { import = "lazyvim.plugins.extras.ui.mini-animate" },
      { import = "lazyvim.plugins.extras.util.mini-hipatterns" },
      { import = "lazyvim.plugins.extras.editor.flash" },
      { import = "plugins" },
    },
    defaults = { lazy = true },
    install = { colorscheme = { "tokyonight", "habamax" } },
    checker = {
      enabled = true,
      frequency = 3600 * 24 * 7, -- check for updates every week
    },
    diff = {
      cmd = "terminal_git",
    },
    performance = {
      cache = {
        enabled = true,
        -- disable_events = {},
      },
      rtp = {
        disabled_plugins = {
          "gzip",
          "matchit",
          "matchparen",
          "netrwPlugin",
          "rplugin",
          "tarPlugin",
          "tohtml",
          "tutor",
          "zipPlugin",
        },
      },
    },
    ui = {
      custom_keys = {
        ["<localleader>d"] = function(plugin)
          dd(plugin)
        end,
      },
    },
    debug = false,
  }, opts or {})
  require("lazy").setup(opts)
end
