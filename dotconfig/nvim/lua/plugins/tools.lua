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

  { "akinsho/toggleterm.nvim", version = "*", cmd = { "ToggleTerm", "TermExec" }, config = true },

  {
    "CRAG666/code_runner.nvim",
    cmd = { "RunCode" },
    keys = { { "<leader>rc", "<cmd>RunCode<cr>", desc = "run code file" } },
    opts = {
      mode = "term",
      term = { size = 40 },
      startinsert = true,
      filetype = {
        java = {
          "cd $dir &&",
          "javac $fileName &&",
          "java $fileNameWithoutExt",
        },
        python = "python3 -u",
        typescript = "deno run",
        rust = {
          "cd $dir &&",
          "rustc $fileName &&",
          "$dir/$fileNameWithoutExt",
        },
        ruby = "ruby $file",
        c = "gcc --std=c11 -g -Wall $file && $dir/a.out",
        -- cpp = "g++ --std=c++14 -g -Wall $fileName && $dir/a.out",
        cpp = {
          "cd $dir &&",
          "g++ --std=c++14 -g -Wall -Wextra -O2 $fileName -o $fileNameWithoutExt &&",
          "$dir/$fileNameWithoutExt",
        },
      },
    },
  },

  {
    "Vigemus/iron.nvim",
    keys = {
      { "<leader>rs", "<cmd>IronRepl<cr>", desc = "Iron Repl" },
      { "<leader>rr", "<cmd>IronRestart<cr>", desc = "Iron Restart" },
      { "<leader>rf", "<cmd>IronFocus<cr>", desc = "Iron Focus" },
      { "<leader>rh", "<cmd>IronHide<cr>", desc = "Iron Hide" },
    },
    config = function()
      local iron = require("iron.core")
      local view = require("iron.view")
      local executable = function(exe)
        return vim.api.nvim_call_function("executable", { exe }) == 1
      end

      iron.setup({
        config = {
          -- Whether a repl should be discarded or not
          scratch_repl = true,
          -- Your repl definitions come here
          repl_definition = {
            python = {
              command = { executable("bpython") and "bpython" or "python" },
            },
            sh = {
              -- Can be a table or a function that
              -- returns a table (see below)
              command = { "zsh" },
            },
          },
          -- How the repl window will be displayed
          -- See below for more information
          -- repl_open_cmd = require("iron.view").bottom(40),
          repl_open_cmd = view.split.vertical.botright(100),
        },
        -- Iron doesn't set keymaps by default anymore.
        -- You can set them here or manually add keymaps to the functions in iron.core
        keymaps = {
          send_motion = "<space>sc",
          visual_send = "<space>sc",
          send_file = "<space>sf",
          send_line = "<space>sl",
          send_until_cursor = "<space>su",
          send_mark = "<space>sm",
          mark_motion = "<space>mc",
          mark_visual = "<space>mc",
          remove_mark = "<space>md",
          cr = "<space>s<cr>",
          interrupt = "<space>s<space>",
          exit = "<space>sq",
          clear = "<space>cl",
        },
        -- If the highlight is on, you can change how it looks
        -- For the available options, check nvim_set_hl
        highlight = {
          italic = true,
        },
        ignore_blank_lines = true, -- ignore blank lines when sending visual select lines
      })
    end,
  },
}
