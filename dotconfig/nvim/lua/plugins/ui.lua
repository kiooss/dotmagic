return {
  -- dashboard
  { "goolord/alpha-nvim", enabled = false },

  -- bufferline
  {
    "akinsho/nvim-bufferline.lua",
    event = "BufAdd",
    opts = {
      options = {
        modified_icon = "",
        numbers = function(opts)
          return string.format("%s", opts.raise(opts.ordinal))
        end,
        show_close_icon = false,
        show_buffer_close_icons = false,
        diagnostics = "nvim_lsp",
        separator_style = "slant",
        diagnostics_indicator = function(_, _, diag)
          local icons = require("lazyvim.config.settings").icons.diagnostics
          local ret = (diag.error and icons.Error .. diag.error .. " " or "")
            .. (diag.warning and icons.Warn .. diag.warning or "")
          return vim.trim(ret)
        end,
        -- diagnostics_indicator = function(_, _, diag)
        --   local s = {}
        --   for _, severity in ipairs(severities) do
        --     if diag[severity] then
        --       table.insert(s, signs[severity] .. diag[severity])
        --     end
        --   end
        --   return table.concat(s, " ")
        -- end,
        offsets = {
          {
            filetype = "NvimTree",
            highlight = "Directory",
            text = " File Explorer",
            text_align = "left",
          },
        },
      },
    },
  },

  -- indent-blankline
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufReadPre",
    opts = {
      buftype_exclude = { "terminal", "nofile" },
      filetype_exclude = {
        "help",
        "startify",
        "dashboard",
        "packer",
        "neogitstatus",
        "NvimTree",
        "neo-tree",
        "Trouble",
      },
      -- char = "│",
      char = "▏",
      use_treesitter_scope = false,
      show_trailing_blankline_indent = false,
      show_current_context = true,
      context_patterns = {
        "class",
        "return",
        "function",
        "method",
        "^if",
        "^while",
        "jsx_element",
        "^for",
        "^object",
        "^table",
        "block",
        "arguments",
        "if_statement",
        "else_clause",
        "jsx_element",
        "jsx_self_closing_element",
        "try_statement",
        "catch_clause",
        "import_statement",
        "operation_type",
      },
    },
  },

  {
    "folke/drop.nvim",
    event = "VimEnter",
    enabled = false,
    config = function()
      math.randomseed(os.time())
      local theme = ({ "stars", "snow", "xmas" })[math.random(1, 3)]
      require("drop").setup({ theme = theme })
    end,
  },
}
