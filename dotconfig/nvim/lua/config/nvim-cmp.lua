local cmp = require("cmp")
local lspkind = require("lspkind")

cmp.setup({
  snippet = {
    expand = function(args)
      -- You must install `vim-vsnip` if you use the following as-is.
      vim.fn["vsnip#anonymous"](args.body)
      -- require("luasnip").lsp_expand(args.body)
    end,
  },

  -- You must set mapping if you want.
  mapping = {
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.close(),
    ["<CR>"] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    }),
    ["<S-Tab>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "s" }),
    ["<Tab>"] = function(fallback)
      if vim.fn.pumvisible() == 1 then
        vim.fn.feedkeys(
          vim.api.nvim_replace_termcodes("<C-n>", true, true, true),
          "n"
        )
      elseif vim.fn["vsnip#available"]() == 1 then
        vim.fn.feedkeys(
          vim.api.nvim_replace_termcodes(
            "<Plug>(vsnip-expand-or-jump)",
            true,
            true,
            true
          ),
          ""
        )
      else
        fallback()
      end
    end,
  },

  formatting = {
    format = function(entry, vim_item)
      vim_item.kind = lspkind.presets.default[vim_item.kind]
      -- set a name for each source
      vim_item.menu = ({
        buffer = "[Buffer]",
        nvim_lsp = "[LSP]",
        luasnip = "[LuaSnip]",
        nvim_lua = "[Lua]",
        vsnip = "[Vsnip]",
        latex_symbols = "[Latex]",
        look = "[Look]",
      })[entry.source.name]

      return vim_item
    end,
  },

  -- You should specify your *installed* sources.
  sources = {
    { name = "nvim_lsp" },
    { name = "buffer" },
    { name = "path" },
    { name = "look" },
    -- { name = "calc" },
    -- { name = "nvim_lua" },
    { name = "vsnip" },
    -- { name = "luasnip" },
  },
})
