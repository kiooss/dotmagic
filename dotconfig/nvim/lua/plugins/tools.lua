return {
  -- better diffing
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
    config = true,
    keys = { { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "DiffView" } },
  },

  -- colorizer
  {
    "NvChad/nvim-colorizer.lua",
    event = "BufReadPre",
    opts = {
      filetypes = { "*", "!lazy" },
      buftype = { "*", "!prompt", "!nofile" },
      user_default_options = {
        RGB = true, -- #RGB hex codes
        RRGGBB = true, -- #RRGGBB hex codes
        names = false, -- "Name" codes like Blue
        RRGGBBAA = true, -- #RRGGBBAA hex codes
        AARRGGBB = false, -- 0xAARRGGBB hex codes
        rgb_fn = true, -- CSS rgb() and rgba() functions
        hsl_fn = true, -- CSS hsl() and hsla() functions
        css = false, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
        css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
        -- Available modes: foreground, background
        -- Available modes for `mode`: foreground, background,  virtualtext
        mode = "background", -- Set the display mode.
        virtualtext = "■",
      },
    },
  },

  -- {
  --   "ojroques/vim-oscyank",
  --   cmd = { "OSCYank", "OSCYankRegister" },
  --   init = function()
  --     vim.g.oscyank_term = "default"
  --   end,
  -- },
  {
    "wincent/vim-clipper",
    lazy = false,
    config = function()
      vim.g.ClipperAddress = "~/.clipper.sock"
      vim.g.ClipperPort = 0

      if vim.fn.filereadable("/etc/arch-release") == 1 and vim.fn.executable("socat") == 1 then
        vim.fn["clipper#set_invocation"]("socat - UNIX-CLIENT:" .. vim.fn.expand(vim.g.ClipperAddress))
      elseif vim.fn.filereadable("/etc/debian_version") == 1 and vim.fn.executable("socat") == 1 then
        vim.fn["clipper#set_invocation"]("socat - UNIX-CLIENT:" .. vim.fn.expand(vim.g.ClipperAddress))
      else
        vim.fn["clipper#set_invocation"]("")
      end
    end,
  },

  {
    "ruifm/gitlinker.nvim",
    keys = { { "<leader>gy", desc = "github permalink" } },
    config = true,
  },
  {
    "jackMort/ChatGPT.nvim",
    cmd = { "ChatGPTActAs", "ChatGPT", "ChatGPTEditWithInstructions" },
    opts = {},
  },
}
