local stylua = function()
  return {
    exe = 'stylua',
    args = { '--config-path', '~/.config/nvim/.stylua', '-' },
    stdin = true,
  }
end

local luafmt = function()
  return {
    exe = 'luafmt',
    args = { '--indent-count', 2, '--stdin' },
    stdin = true,
  }
end

local shfmt = function()
  return {
    exe = 'shfmt',
    args = { '-i', 2 },
    stdin = true,
  }
end

local prettier = function()
  return {
    exe = 'prettier',
    args = { '--stdin-filepath', vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)) },
    stdin = true,
  }
end

local rubocop = function()
  return {
    exe = 'rubocop', -- might prepend `bundle exec `
    args = { '--auto-correct-all', '--stdin', '%:p', '2>/dev/null', '|', "awk 'f; /^====================$/{f=1}'" },
    stdin = true,
  }
end

require('formatter').setup({
  filetype = {
    lua = { stylua },
    sh = { shfmt },
    javascript = { prettier },
    vue = { prettier },
    ruby = { rubocop },
  },
})
