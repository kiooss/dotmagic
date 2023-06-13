return {
  {
    "rcarriga/nvim-notify",
    opts = {
      background_colour = "#000000",
    },
  },

  -- floating winbar
  {
    "b0o/incline.nvim",
    event = "BufReadPre",
    config = function()
      local colors = require("tokyonight.colors").setup()
      require("incline").setup({
        highlight = {
          groups = {
            InclineNormal = { guibg = "#FC56B1", guifg = colors.black },
            InclineNormalNC = { guifg = "#FC56B1", guibg = colors.black },
          },
        },
        window = { margin = { vertical = 0, horizontal = 1 } },
        render = function(props)
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
          local icon, color = require("nvim-web-devicons").get_icon_color(filename)
          return { { icon, guifg = color }, { " " }, { filename } }
        end,
      })
    end,
  },

  -- dashboard
  { "goolord/alpha-nvim", enabled = true },

  -- bufferline
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        -- always_show_bufferline = true,
        modified_icon = "",
        numbers = function(opts)
          return string.format("%s", opts.raise(opts.ordinal))
        end,
        show_close_icon = false,
        show_buffer_close_icons = false,
        separator_style = "thin",
        -- separator_style = "slant" | "slope" | "thick" | "thin" | { 'any', 'any' },
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
      -- char = "▏",
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

  -- noicer ui
  {
    "folke/noice.nvim",
    lazy = false,
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      presets = {
        bottom_search = false,
        command_palette = false,
        long_message_to_split = true,
        inc_rename = true,
      },
    },
  },

  -- style windows with different colorschemes
  {
    "folke/styler.nvim",
    event = "VeryLazy",
    opts = {
      themes = {
        markdown = { colorscheme = "catppuccin" },
        help = { colorscheme = "catppuccin", background = "dark" },
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

  {
    "echasnovski/mini.hipatterns",
    opts = function(_, opts)
      vim.list_extend(opts.tailwind.ft, {
        "eruby",
      })
    end,
  },
}
