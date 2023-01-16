return {
  -- dashboard
  { "goolord/alpha-nvim", enabled = true },

  -- bufferline
  {
    "akinsho/nvim-bufferline.lua",
    opts = {
      options = {
        always_show_bjufferline = true,
        modified_icon = "",
        numbers = function(opts)
          return string.format("%s", opts.raise(opts.ordinal))
        end,
        show_close_icon = false,
        show_buffer_close_icons = false,
        separator_style = "slant",
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

  -- noicer ui
  {
    "folke/noice.nvim",
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
    enabled = false,
    opts = {
      themes = {
        markdown = { colorscheme = "tokyonight-storm" },
        help = { colorscheme = "oxocarbon", background = "dark" },
        noice = { colorscheme = "gruvbox", background = "dark" },
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
