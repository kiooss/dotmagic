local function leader_map()
  vim.g.mapleader = " "
  vim.g.maplocalleader = ","
end

local function disable_distribution_plugins()
  vim.g.loaded_gzip = 1
  vim.g.loaded_tar = 1
  vim.g.loaded_tarPlugin = 1
  vim.g.loaded_zip = 1
  vim.g.loaded_zipPlugin = 1
  vim.g.loaded_getscript = 1
  vim.g.loaded_getscriptPlugin = 1
  vim.g.loaded_vimball = 1
  vim.g.loaded_vimballPlugin = 1
  vim.g.loaded_matchit = 1
  vim.g.loaded_matchparen = 1
  vim.g.loaded_2html_plugin = 1
  vim.g.loaded_logiPat = 1
  vim.g.loaded_rrhelper = 1
  vim.g.loaded_netrw = 1
  vim.g.loaded_netrwPlugin = 1
  vim.g.loaded_netrwSettings = 1
  vim.g.loaded_netrwFileHandlers = 1
end

local function load_core()
  -- local pack = require('core.pack')
  -- createdir()
  -- disable_distribution_plugins()
  -- leader_map()

  -- pack.ensure_plugins()
  -- neovide_config()
  -- dashboard_config()

  -- require('core.options')
  -- require('core.mapping')
  -- require('keymap')
  -- require('core.event')
  -- pack.load_compile()

  -- vim.cmd [[colorscheme edge]]
  disable_distribution_plugins()
  leader_map()
  require("util")
  require("core.options")

  -- no need to load this immediately, since we have packer_compiled
  vim.defer_fn(function()
    require("plugins")
  end, 0)

  vim.cmd("source ~/.config/nvim/viml/autocmds.vim")
  vim.cmd("source ~/.config/nvim/viml/mappings.vim")
  vim.cmd("source ~/.config/nvim/viml/abbr.vim")
  vim.cmd("source ~/.config/nvim/custom_highlight.vim")
end

load_core()
