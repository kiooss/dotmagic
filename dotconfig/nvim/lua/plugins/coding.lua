return {
  {
    "saghen/blink.cmp",
    opts = {
      keymap = {
        preset = "enter",
        ["<Tab>"] = {
          "select_next",
          "snippet_forward",
          "fallback",
        },

        ["<S-Tab>"] = {
          "select_prev",
          "snippet_backward",
          "fallback",
        },
      },
      sources = {
        providers = {
          buffer = {
            opts = {
              get_bufnrs = function()
                return vim
                  .iter(vim.api.nvim_list_wins())
                  :map(function(win)
                    return vim.api.nvim_win_get_buf(win)
                  end)
                  :filter(function(buf)
                    return vim.bo[buf].buftype ~= "nofile" or vim.bo[buf].filetype == "git"
                  end)
                  :totable()
              end,
            },
          },
        },
      },
    },
  },

  {
    "hrsh7th/nvim-cmp",
    enabled = false,
    dependencies = {
      "hrsh7th/cmp-cmdline",
      "dmitmel/cmp-cmdline-history",
      "octaltree/cmp-look",
    },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      table.insert(
        opts.sources,
        { name = "look", keyword_length = 3, option = { convert_case = true, loud = true }, group_index = 0 }
      )

      local cmp = require("cmp")

      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

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
          { name = "cmdline" },
        }),
      })

      cmp.setup.filetype("gitcommit", {
        sources = cmp.config.sources({
          { name = "snippets" },
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
        }),
      })

      opts.window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
      }

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
        ["<Tab>"] = function(fallback)
          if vim.snippet.active({ direction = 1 }) then
            vim.snippet.jump(1)
          else
            if not cmp.select_next_item() then
              if vim.bo.buftype ~= "prompt" and has_words_before() then
                cmp.complete()
              else
                fallback()
              end
            end
          end
        end,
        ["<S-Tab>"] = function(fallback)
          if vim.snippet.active({ direction = 1 }) then
            vim.snippet.jump(-1)
          else
            if not cmp.select_prev_item() then
              if vim.bo.buftype ~= "prompt" and has_words_before() then
                cmp.complete()
              else
                fallback()
              end
            end
          end
        end,

        -- ["<Tab>"] = cmp.mapping(function(fallback)
        --   if cmp.visible() then
        --     cmp.select_next_item()
        --     -- elseif luasnip.expand_or_jumpable() then
        --     --   luasnip.expand_or_jump()
        --     -- elseif vim.fn['vsnip#available']() == 1 then
        --     --   feedkey('<Plug>(vsnip-expand-or-jump)', '')
        --   elseif has_words_before() then
        --     cmp.complete()
        --   else
        --     fallback()
        --   end
        -- end, {
        --   "i",
        --   "s",
        -- }),
        -- ["<S-Tab>"] = cmp.mapping(function(fallback)
        --   if cmp.visible() then
        --     cmp.select_prev_item()
        --     -- elseif luasnip.jumpable(-1) then
        --     --   luasnip.jump(-1)
        --     -- elseif vim.fn['vsnip#jumpable'](-1) == 1 then
        --     --   feedkey('<Plug>(vsnip-jump-prev)', '')
        --   else
        --     fallback()
        --   end
        -- end, {
        --   "i",
        --   "s",
        -- }),
      })
    end,
  },

  -- snippets
  -- {
  --   "L3MON4D3/LuaSnip",
  --   -- dependencies = {
  --   --   "rafamadriz/friendly-snippets",
  --   --   config = function()
  --   --     require("luasnip.loaders.from_vscode").lazy_load()
  --   --   end,
  --   -- },
  --   opts = {
  --     history = true,
  --     delete_check_events = "TextChanged",
  --     enable_autosnippets = true,
  --     updateevents = "TextChanged,TextChangedI",
  --   },
  --   keys = function()
  --     return {}
  --   end,
  --   config = function(_, opts)
  --     local luasnip = require("luasnip")
  --     require("neogen")
  --     luasnip.config.setup(opts)
  --     luasnip.filetype_extend("all", { "_" })
  --     luasnip.filetype_extend("ruby", { "rails" })
  --     luasnip.filetype_extend("eruby", { "html" })
  --
  --     require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/lua/yy/snippets" })
  --
  --     -- keymaps
  --     -- <c-l> is selecting within a list of options.
  --     -- This is useful for choice nodes (introduced in the forthcoming episode 2)
  --     vim.keymap.set("i", "<c-l>", function()
  --       if luasnip.choice_active() then
  --         luasnip.change_choice(1)
  --       end
  --     end)
  --
  --     -- vim.keymap.set("i", "<c-u>", require("luasnip.extras.select_choice"))
  --
  --     vim.keymap.set("n", "<leader>se", function()
  --       require("luasnip.loaders.from_lua").edit_snippet_files()
  --     end, { desc = "Edit snippet files" })
  --   end,
  -- },
  --
  {
    "garymjr/nvim-snippets",
    opts = {
      extended_filetypes = {
        ruby = { "rails" },
        eruby = { "html" },
        all = { "_" },
        sh = { "shelldoc" },
        blade = { "html" },
      },
    },
  },

  -- {
  --   "danymat/neogen",
  --   keys = {
  --     {
  --       "<leader>cc",
  --       function()
  --         require("neogen").generate({})
  --       end,
  --       desc = "Neogen Comment",
  --     },
  --   },
  --   opts = { snippet_engine = "luasnip" },
  -- },

  -- {
  --   "smjonas/inc-rename.nvim",
  --   cmd = "IncRename",
  --   config = true,
  -- },

  {
    "ThePrimeagen/refactoring.nvim",
    keys = {
      {
        "<leader>r",
        function()
          require("refactoring").select_refactor()
        end,
        mode = "v",
        noremap = true,
        silent = true,
        expr = false,
      },
    },
    opts = {},
  },

  {
    "simrat39/symbols-outline.nvim",
    keys = { { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
    config = true,
  },

  {
    "pechorin/any-jump.vim",
    cmd = { "AnyJump", "AnyJumpVisual" },
    keys = { { "<leader>j", "<cmd>AnyJump<cr>", desc = "AnyJump" } },
  },

  -- better increase/descrease
  {
    "monaqa/dial.nvim",
    -- stylua: ignore
    keys = {
      { "<C-a>", function() return require("dial.map").inc_normal() end, expr = true, desc = "Increment" },
      { "<C-x>", function() return require("dial.map").dec_normal() end, expr = true, desc = "Decrement" },
    },
    config = function()
      local augend = require("dial.augend")
      require("dial.config").augends:register_group({
        default = {
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          augend.date.alias["%Y/%m/%d"],
          augend.constant.alias.bool,
          augend.semver.alias.semver,
        },
      })
    end,
  },

  -- copilot
  -- {
  --   "zbirenbaum/copilot.lua",
  --   enabled = false,
  --   event = "VeryLazy",
  --   opts = {
  --     suggestion = {
  --       enabled = true,
  --       auto_trigger = true,
  --       debounce = 75,
  --       keymap = {
  --         accept = "<C-j>",
  --         accept_word = false,
  --         accept_line = false,
  --         next = "<M-]>",
  --         prev = "<M-[>",
  --         dismiss = "<C-]>",
  --       },
  --     },
  --     filetypes = {
  --       sh = function()
  --         if string.match(vim.fs.basename(vim.api.nvim_buf_get_name(0)), "^%.env.*") then
  --           -- disable for .env files
  --           return false
  --         end
  --         return true
  --       end,
  --     },
  --   },
  -- },
  --
  -- {
  --   "github/copilot.vim",
  --   enabled = false,Exafunction/codeium.vim
  --   event = "VeryLazy",
  --   init = function()
  --     vim.g.copilot_no_tab_map = 1
  --     vim.g.copilot_filetypes = {
  --       spectre_panel = false,
  --     }
  --     vim.keymap.set("i", "<c-j>", 'copilot#Accept("<CR>")', { expr = true })
  --   end,
  -- },
  -- {
  --   "Exafunction/codeium.vim",
  --   event = "InsertEnter",
  --   enabled = false,
  --   config = function()
  --     -- Change '<C-g>' here to any keycode you like.
  --     vim.keymap.set("i", "<C-j>", function()
  --       return vim.fn["codeium#Accept"]()
  --     end, { expr = true })
  --     vim.keymap.set("i", "<c-x>", function()
  --       return vim.fn["codeium#Clear"]()
  --     end, { expr = true })
  --   end,
  -- },

  { -- lazy
    "ccaglak/namespace.nvim",
    keys = {
      { "<leader>ci", "<cmd>Php class<cr>", "PHP import namespace" },
      { "<leader>la", "<cmd>Php classes<cr>" },
      { "<leader>lc", "<cmd>Php class<cr>" },
      { "<leader>ln", "<cmd>Php namespace<cr>" },
      { "<leader>ls", "<cmd>Php sort<cr>" },
    },
    dependencies = {
      "ccaglak/phptools.nvim", -- optional
      "ccaglak/larago.nvim", -- optional
    },
    opts = {
      ui = true, -- default: true -- false only if you want to use your own ui
      cacheOnload = false, -- default: false -- cache composer.json on load
      dumpOnload = false, -- default: false -- dump composer.json on load
      sort = {
        on_save = false, -- default: false -- sorts on every search
        sort_type = "length_desc", -- default: natural -- seam like what pint is sorting
        --  ascending -- descending -- length_asc
        -- length_desc -- natural -- case_insensitive
      },
    },
  },
}
