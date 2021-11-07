local cmp = require('cmp')

local function t(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

cmp.setup({
  snippet = {
    expand = function(args)
      -- You must install `vim-vsnip` if you use the following as-is.
      vim.fn['vsnip#anonymous'](args.body)
      -- require("luasnip").lsp_expand(args.body)
    end,
  },

  -- You must set mapping if you want.
  mapping = {
    ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    ['<C-l>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<C-e>'] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    ['<CR>'] = cmp.mapping.confirm({
      -- behavior = cmp.ConfirmBehavior.Insert,
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    }),
    ['<S-Tab>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 's' }),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif vim.fn['vsnip#available']() == 1 then
        vim.fn.feedkeys(t('<Plug>(vsnip-expand-or-jump)'), '')
      else
        vim.fn.feedkeys(t('<Plug>(Tabout)'), '')
        -- fallback()
      end
    end, {
      'i',
      's',
      'c',
    }),
    -- ['<Tab>'] = cmp.mapping(function(fallback)
    --   if cmp.visible() then
    --     cmp.select_next_item()
    --     -- elseif luasnip.expand_or_jumpable() then
    --     --   luasnip.expand_or_jump()
    --   elseif vim.fn['vsnip#available']() == 1 then
    --     vim.fn.feedkeys(t('<Plug>(vsnip-expand-or-jump)'), '')
    --   elseif has_words_before() then
    --     cmp.complete()
    --   else
    --     local copilot_keys = vim.fn['copilot#Accept']()
    --     if copilot_keys ~= '' then
    --       vim.api.nvim_feedkeys(copilot_keys, 'i', true)
    --     else
    --       fallback()
    --     end
    --   end
    -- end, {
    --   'i',
    --   's',
    -- }),
    -- ['<C-j>'] = cmp.mapping(function(fallback)
    --   local copilot_keys = vim.fn['copilot#Accept']()
    --   if copilot_keys ~= '' then
    --     vim.api.nvim_feedkeys(copilot_keys, 'i', true)
    --   else
    --     fallback()
    --   end
    -- end, {
    --   'i',
    --   's',
    -- }),

    -- ['<Tab>'] = function(fallback)
    --   if cmp.visible() then
    --     cmp.select_next_item()
    --   elseif vim.fn['vsnip#available']() == 1 then
    --     vim.fn.feedkeys(t('<Plug>(vsnip-expand-or-jump)'), '')
    --   else
    --     fallback()
    --   end
    -- end,
  },

  formatting = {
    format = require('lspkind').cmp_format({ with_text = true }),
    -- format = function(entry, vim_item)
    --   vim_item.kind = lspkind.presets.default[vim_item.kind]
    --   -- set a name for each source
    --   vim_item.menu = ({
    --     buffer = '[Buffer]',
    --     nvim_lsp = '[LSP]',
    --     luasnip = '[LuaSnip]',
    --     nvim_lua = '[Lua]',
    --     vsnip = '[Vsnip]',
    --     latex_symbols = '[Latex]',
    --     look = '[Look]',
    --   })[entry.source.name]

    --   return vim_item
    -- end,
  },

  -- You should specify your *installed* sources.
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' }, -- For vsnip users.
  }, {
    { name = 'nvim_lua' },
    { name = 'buffer' },
    { name = 'path' },
    { name = 'look', keyword_length = 2 },
  }),

  experimental = {
    ghost_text = {
      hl_group = 'LineNr',
    },
  },
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
  sources = {
    { name = 'buffer' },
  },
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  sources = cmp.config.sources({
    { name = 'path' },
  }, {
    { name = 'cmdline' },
  }),
})
