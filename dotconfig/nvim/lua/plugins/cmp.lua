local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

return {
  "hrsh7th/nvim-cmp",
  -- ft = "gitcommit",
  event = "VeryLazy",
  dependencies = {
    "hrsh7th/cmp-emoji",
    "hrsh7th/cmp-cmdline",
    "dmitmel/cmp-cmdline-history",
    "hrsh7th/cmp-nvim-lua",
    "onsails/lspkind.nvim",
    "octaltree/cmp-look",
  },
  opts = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")

    return {
      mapping = cmp.mapping.preset.insert({
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-e>"] = cmp.mapping({
          i = cmp.mapping.abort(),
          c = cmp.mapping.close(),
        }),
        ["<C-y>"] = cmp.mapping(
          cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
          }),
          { "i", "c" }
        ),
        ["<M-y>"] = cmp.mapping(
          cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          }),
          { "i", "c" }
        ),
        ["<CR>"] = cmp.mapping.confirm({
          -- default is cmp.CompeConfirmBehavior.Insert
          behavior = cmp.ConfirmBehavior.Insert,
          select = true,
        }),
        ["<Tab>"] = cmp.mapping(function(fallback)
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
          "i",
          "s",
        }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
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
          "i",
          "s",
        }),
      }),
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "nvim_lua" },
        { name = "buffer" },
        { name = "treesitter" },
        { name = "path" },
        { name = "tmux" },
        { name = "emoji" },
        { name = "look", keyword_length = 2, option = { convert_case = true, loud = true } },
      }),
      formatting = {
        format = require("lspkind").cmp_format({
          with_text = true,
          menu = {
            look = "[look]",
            nvim_lsp = "[LSP]",
            nvim_lua = "[neovim Lua API]",
            treesitter = "[treesitter]",
            path = "[path]",
            buffer = "[buffer]",
            zsh = "[zsh]",
            vsnip = "[vsnip]",
            luasnip = "[luasnip]",
            spell = "[spell]",
            tmux = "[tmux]",
            cmdline = "[cmdline]",
            cmdline_history = "[cmdline_history]",
          },
        }),
      },
    }
  end,
  config = function(_, opts)
    local cmp = require("cmp")
    cmp.setup(opts)

    cmp.setup.filetype("gitcommit", {
      sources = cmp.config.sources({
        { name = "luasnip" },
        {
          name = "buffer",
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
        { name = "look", keyword_length = 2, option = { convert_case = true, loud = true } },
      }),
    })

    -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline("/", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = "buffer" },
      }),
    })

    -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = "path" },
      }, {
        -- { name = 'cmdline_history', keyword_length = 3 },
        { name = "cmdline" },
      }),
    })
  end,
  -- config = function()
  --   -- Setup nvim-cmp.
  --   local cmp = require("cmp")
  --   local luasnip = require("luasnip")
  --
  --   cmp.setup({
  --     completion = {
  --       completeopt = "menu,menuone,noinsert",
  --     },
  --
  --     window = {
  --       completion = cmp.config.window.bordered(),
  --       documentation = cmp.config.window.bordered(),
  --     },
  --
  --     snippet = {
  --       expand = function(args)
  --         require("luasnip").lsp_expand(args.body)
  --       end,
  --     },
  --
  --     -- formatting = {
  --     --   format = require("lspkind").cmp_format({
  --     --     with_text = true,
  --     --     menu = {
  --     --       look = "[look]",
  --     --       nvim_lsp = "[LSP]",
  --     --       nvim_lua = "[api]",
  --     --       treesitter = "[treesitter]",
  --     --       path = "[path]",
  --     --       buffer = "[buffer]",
  --     --       zsh = "[zsh]",
  --     --       vsnip = "[vsnip]",
  --     --       luasnip = "[luasnip]",
  --     --       spell = "[spell]",
  --     --       tmux = "[tmux]",
  --     --       cmdline = "[cmdline]",
  --     --       cmdline_history = "[cmdline_history]",
  --     --       -- look = '',
  --     --       -- nvim_lsp = '',
  --     --       -- nvim_lua = '',
  --     --       -- treesitter = '',
  --     --       -- path = '',
  --     --       -- buffer = '﬘',
  --     --       -- zsh = '',
  --     --       -- vsnip = '',
  --     --       -- spell = '暈',
  --     --     },
  --     --   }),
  --     -- },
  --
  --     -- formatting = {
  --     --   format = require('plugins.lsp.kind').cmp_format(),
  --     -- },
  --     -- documentation = {
  --     --   border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
  --     --   winhighlight = "NormalFloat:NormalFloat,FloatBorder:TelescopeBorder",
  --     -- },
  --     experimental = {
  --       ghost_text = {
  --         hl_group = "LspCodeLens",
  --       },
  --     },
  --     -- sorting = {
  --     --   comparators = {
  --     --     cmp.config.compare.sort_text,
  --     --     cmp.config.compare.offset,
  --     --     -- cmp.config.compare.exact,
  --     --     cmp.config.compare.score,
  --     --     -- cmp.config.compare.kind,
  --     --     -- cmp.config.compare.length,
  --     --     cmp.config.compare.order,
  --     --   },
  --     -- },
  --   })
  --
  --   cmp.setup.filetype("gitcommit", {
  --     sources = cmp.config.sources({
  --       { name = "luasnip" },
  --       {
  --         name = "buffer",
  --         option = {
  --           -- Options go into this table
  --           get_bufnrs = function()
  --             local bufs = {}
  --             for _, win in ipairs(vim.api.nvim_list_wins()) do
  --               bufs[vim.api.nvim_win_get_buf(win)] = true
  --             end
  --             return vim.tbl_keys(bufs)
  --           end,
  --         },
  --       },
  --       { name = "look", keyword_length = 2, option = { convert_case = true, loud = true } },
  --     }),
  --   })
  --
  --   -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
  --   cmp.setup.cmdline("/", {
  --     mapping = cmp.mapping.preset.cmdline(),
  --     sources = cmp.config.sources({
  --       { name = "buffer" },
  --     }),
  --   })
  --
  --   -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  --   cmp.setup.cmdline(":", {
  --     mapping = cmp.mapping.preset.cmdline(),
  --     sources = cmp.config.sources({
  --       { name = "path" },
  --     }, {
  --       -- { name = 'cmdline_history', keyword_length = 3 },
  --       { name = "cmdline" },
  --     }),
  --   })
  -- end,
}
