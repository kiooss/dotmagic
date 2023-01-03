local cmp = require('cmp')
local luasnip = require('luasnip')

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

cmp.setup({
  snippet = {
    expand = function(args)
      -- You must install `vim-vsnip` if you use the following as-is.
      -- vim.fn['vsnip#anonymous'](args.body)
      require('luasnip').lsp_expand(args.body)
    end,
  },

  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },

  mapping = cmp.mapping.preset.insert({
    ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
    ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    -- ['<C-l>'] = cmp.mapping.complete(), -- use tab to invoke
    ['<C-e>'] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    ['<CR>'] = cmp.mapping.confirm({
      -- default is cmp.CompeConfirmBehavior.Insert
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    }),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
        -- elseif vim.fn['vsnip#available']() == 1 then
        --   feedkey('<Plug>(vsnip-expand-or-jump)', '')
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, {
      'i',
      's',
    }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
        -- elseif vim.fn['vsnip#jumpable'](-1) == 1 then
        --   feedkey('<Plug>(vsnip-jump-prev)', '')
      else
        fallback()
      end
    end, {
      'i',
      's',
    }),
  }),

  formatting = {
    format = require('lspkind').cmp_format({
      with_text = true,
      menu = {
        look = '[look]',
        nvim_lsp = '[LSP]',
        nvim_lua = '[api]',
        treesitter = '[treesitter]',
        path = '[path]',
        buffer = '[buffer]',
        zsh = '[zsh]',
        vsnip = '[vsnip]',
        luasnip = '[luasnip]',
        spell = '[spell]',
        tmux = '[tmux]',
        cmdline = '[cmdline]',
        cmdline_history = '[cmdline_history]',
        -- look = '',
        -- nvim_lsp = '',
        -- nvim_lua = '',
        -- treesitter = '',
        -- path = '',
        -- buffer = '﬘',
        -- zsh = '',
        -- vsnip = '',
        -- spell = '暈',
      },
    }),
  },

  -- You should specify your *installed* sources.
  sources = cmp.config.sources({
    -- { name = 'vsnip' }, -- For vsnip users.
    { name = 'luasnip' }, -- For luasnip users.
    { name = 'nvim_lsp' },
    -- }, {
    { name = 'nvim_lua' },
    { name = 'buffer' },
    { name = 'treesitter' },
    { name = 'nvim_lsp_signature_help' },
    { name = 'path' },
    { name = 'tmux' },
    { name = 'emoji' },
    { name = 'look', keyword_length = 2, option = { convert_case = true, loud = true } },
  }),

  sorting = {
    comparators = {
      cmp.config.compare.offset,
      cmp.config.compare.exact,
      cmp.config.compare.score,

      -- copied from cmp-under, but I don't think I need the plugin for this.
      -- I might add some more of my own.
      function(entry1, entry2)
        local _, entry1_under = entry1.completion_item.label:find('^_+')
        local _, entry2_under = entry2.completion_item.label:find('^_+')
        entry1_under = entry1_under or 0
        entry2_under = entry2_under or 0
        if entry1_under > entry2_under then
          return false
        elseif entry1_under < entry2_under then
          return true
        end
      end,

      cmp.config.compare.kind,
      cmp.config.compare.sort_text,
      cmp.config.compare.length,
      cmp.config.compare.order,
    },
  },

  experimental = {
    -- native_menu = true,
    ghost_text = {
      hl_group = 'LineNr',
    },
    -- ghost_text = false,
  },
})

cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'luasnip' },
    {
      name = 'buffer',
      option = {
        -- Options go into this table
        get_bufnrs = function()
          local bufs = {}
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            bufs[vim.api.nvim_win_get_buf(win)] = true
          end
          return vim.tbl_keys(bufs)
        end,
      },
    },
    { name = 'look', keyword_length = 2, option = { convert_case = true, loud = true } },
  }),
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'buffer' },
  }),
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' },
  }, {
    -- { name = 'cmdline_history', keyword_length = 3 },
    { name = 'cmdline' },
  }),
})