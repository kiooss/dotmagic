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
    "ruifm/gitlinker.nvim",
    keys = { { "<leader>gy", desc = "github permalink" } },
    config = true,
  },
  {
    "CRAG666/code_runner.nvim",
    cmd = { "RunCode" },
    keys = {
      { "<leader>rc", "<cmd>RunCode<cr>", desc = "Run code" },
      { "<F5>", "<cmd>RunCode<cr>", desc = "Run code" },
    },
    opts = {
      mode = "float", -- "term",
      term = { size = 40 },
      float = {
        border = "double",
        height = 0.7,
        width = 0.5,
      },
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
        -- cpp = {
        --   "cd $dir &&",
        --   "g++ --std=c++14 -O0 -g -Wall -Wextra $fileName -o $fileNameWithoutExt &&",
        --   "$dir/$fileNameWithoutExt",
        -- },
        cpp = {
          "cd $dir && mkdir -p build &&",
          "clang++ -I/usr/local/include --std=c++14 -O0 -g -Wall -Wextra -fsanitize=undefined $fileName -o build/$fileNameWithoutExt &&",
          "$dir/build/$fileNameWithoutExt",
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
        -- under <leader>i so they don't clobber LazyVim's <leader>s (search) / <leader>c (code) maps
        keymaps = {
          send_motion = "<leader>ic",
          visual_send = "<leader>ic",
          send_file = "<leader>if",
          send_line = "<leader>il",
          send_until_cursor = "<leader>iu",
          send_mark = "<leader>im",
          mark_motion = "<leader>ik",
          mark_visual = "<leader>ik",
          remove_mark = "<leader>id",
          cr = "<leader>i<cr>",
          interrupt = "<leader>i<space>",
          exit = "<leader>iq",
          clear = "<leader>ix",
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
