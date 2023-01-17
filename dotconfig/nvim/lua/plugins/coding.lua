return {
  -- snippets
  {
    "L3MON4D3/LuaSnip",
    -- dependencies = {
    --   "rafamadriz/friendly-snippets",
    --   config = function()
    --     require("luasnip.loaders.from_vscode").lazy_load()
    --   end,
    -- },
    opts = {
      history = true,
      delete_check_events = "TextChanged",
      enable_autosnippets = true,
      updateevents = "TextChanged,TextChangedI",
    },
    keys = function()
      return {}
    end,
    config = function(_, opts)
      local luasnip = require("luasnip")
      require("neogen")
      luasnip.config.setup(opts)
      luasnip.filetype_extend("all", { "_" })
      luasnip.filetype_extend("ruby", { "rails" })

      require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/lua/yy/snippets" })

      -- keymaps
      -- <c-l> is selecting within a list of options.
      -- This is useful for choice nodes (introduced in the forthcoming episode 2)
      vim.keymap.set("i", "<c-l>", function()
        if luasnip.choice_active() then
          luasnip.change_choice(1)
        end
      end)

      -- vim.keymap.set("i", "<c-u>", require("luasnip.extras.select_choice"))

      vim.keymap.set("n", "<leader>se", function()
        require("luasnip.loaders.from_lua").edit_snippet_files()
      end, { desc = "Edit snippet files" })
    end,
  },

  {
    "danymat/neogen",
    keys = {
      {
        "<leader>cc",
        function()
          require("neogen").generate({})
        end,
        desc = "Neogen Comment",
      },
    },
    opts = { snippet_engine = "luasnip" },
  },

  {
    "smjonas/inc-rename.nvim",
    cmd = "IncRename",
    config = true,
  },

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
}
