local use_dev = false

if use_dev then
  -- use the local project
  vim.opt.runtimepath:prepend(vim.fn.expand('~/projects/lazy.nvim'))
else
  local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
  if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({ 'git', 'clone', '--filter=blob:none', 'https://github.com/folke/lazy.nvim.git', lazypath })
    vim.fn.system({ 'git', '-C', lazypath, 'checkout', 'tags/stable' }) -- last stable release
  end
  vim.opt.rtp:prepend(lazypath)
end

require('lazy').setup('plugins', {
  defaults = { lazy = true },
  -- dev = { patterns = jit.os:find('Windows') and {} or { 'folke' } },
  install = { colorscheme = { 'tokyonight', 'habamax' } },
  checker = { enabled = true },
  diff = {
    cmd = 'terminal_git',
  },
  performance = {
    cache = {
      enabled = true,
      -- disable_events = {},
    },
    rtp = {
      disabled_plugins = {
        'gzip',
        'matchit',
        'matchparen',
        'netrwPlugin',
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin',
        'nvim-treesitter-textobjects',
      },
    },
  },
  ui = {
    custom_keys = {
      ['<localleader>d'] = function(plugin)
        dd(plugin)
      end,
    },
  },
  -- debug = true,
})
vim.keymap.set('n', '<leader>ly', '<cmd>:Lazy<cr>')
