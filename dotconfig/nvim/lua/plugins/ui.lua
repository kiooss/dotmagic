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
  -- { "goolord/alpha-nvim", enabled = true },

  -- bufferline
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        indicator = {
          style = "underline",
        },
        -- always_show_bufferline = true,
        modified_icon = "",
        numbers = function(opts)
          return string.format("%s", opts.raise(opts.ordinal))
        end,
        show_close_icon = false,
        show_buffer_close_icons = false,
        separator_style = { "", "" },
        -- separator_style = "thin",
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
    "echasnovski/mini.hipatterns",
    opts = function(_, opts)
      vim.list_extend(opts.tailwind.ft, {
        "eruby",
      })
    end,
  },
}
