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
          snippets = {
            opts = {
              extended_filetypes = {
                ruby = { "rails" },
                eruby = { "html" },
                sh = { "shelldoc" },
                blade = { "html" },
              },
            },
          },
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

  { -- lazy
    "ccaglak/namespace.nvim",
    keys = {
      { "<leader>ci", "<cmd>Php class<cr>", desc = "PHP import namespace" },
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
