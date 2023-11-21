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
    "octaltree/cmp-look",
  },
  ---@param opts cmp.ConfigSchema
  opts = function(_, opts)
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    local sources = {
      { name = "nvim_lua" },
      { name = "treesitter" },
      { name = "tmux" },
      { name = "emoji" },
      { name = "look", keyword_length = 3, option = { convert_case = true, loud = true } },
    }
    opts.sources = cmp.config.sources(vim.list_extend(opts.sources, sources))
    opts.mapping = cmp.mapping.preset.insert({
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
    })
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
        -- { name = "look", keyword_length = 3, option = { convert_case = true, loud = true } },
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
}
