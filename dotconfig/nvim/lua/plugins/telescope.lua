return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    { "nvim-telescope/telescope-file-browser.nvim" },
    { "nvim-telescope/telescope-live-grep-args.nvim" },
    { "nvim-telescope/telescope-symbols.nvim" },
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  keys = {
    {
      "<leader>/",
      function()
        require("telescope").extensions.live_grep_args.live_grep_args()
      end,
      desc = "Searches string",
    },
    {
      "<leader>fw",
      function()
        require("telescope.builtin").live_grep({ search_dirs = { "~/vimwiki/" } })
      end,
      desc = "Searches wiki",
    },
    {
      "<leader>*",
      function()
        require("telescope.builtin").grep_string()
      end,
      desc = "Searches string under cursor",
    },
    {
      "<leader>.",
      function()
        require("telescope.builtin").resume()
      end,
      desc = "Telescope resume",
    },
    {
      "<leader>fp",
      function()
        require("telescope.builtin").find_files({
          cwd = require("lazy.core.config").options.root,
        })
      end,
      desc = "Find Plugin File",
    },
    { "<leader>gb", "<cmd>Telescope git_bcommits<CR>", desc = "buffer commits" },
    { "<M-b>", "<cmd>Telescope buffers<CR>", desc = "Buffers" },
  },
  opts = function()
    local actions = require("telescope.actions")
    local trouble = require("trouble.providers.telescope")
    local borderless = true
    local lga_actions = require("telescope-live-grep-args.actions")

    return {
      defaults = {
        file_ignore_patterns = { ".git/", "node_modules" },
        -- layout_config = {
        --   preview_width = 0.6,
        --   prompt_position = "top",
        -- },
        path_display = { "smart" },
        -- prompt_position = "top",
        prompt_prefix = " ",
        selection_caret = " ",
        -- sorting_strategy = "ascending",
        winblend = borderless and 0 or 10,
        mappings = {
          i = {
            ["<C-u>"] = false, -- Mapping <C-u> to clear prompt
            ["<c-t>"] = trouble.open_with_trouble,
            ["<c-j>"] = actions.move_selection_next,
            ["<c-k>"] = actions.move_selection_previous,
            ["<C-Down>"] = require("telescope.actions").cycle_history_next,
            ["<C-Up>"] = require("telescope.actions").cycle_history_prev,
            ["<esc>"] = actions.close,
            ["<C-h>"] = actions.which_key,
          },
        },
      },
      pickers = {
        buffers = {
          prompt_prefix = "﬘ ",
        },
        commands = {
          prompt_prefix = " ",
        },
        git_files = {
          prompt_prefix = " ",
          show_untracked = true,
        },
        find_files = {
          prompt_prefix = " ",
          find_command = { "rg", "--files", "--hidden" },
        },
      },
      extensions = {
        -- fzy_native = { override_generic_sorter = false, override_file_sorter = true },
        fzf = {
          fuzzy = true, -- false will only do exact matching
          override_generic_sorter = true, -- override the generic sorter
          override_file_sorter = true, -- override the file sorter
          case_mode = "smart_case", -- or "ignore_case" or "respect_case"
          -- the default case_mode is "smart_case"
        },
        -- frecency = {
        --   show_scores = true,
        --   default_workspace = "CWD",
        -- },
        live_grep_args = {
          auto_quoting = true, -- enable/disable auto-quoting
          -- define mappings, e.g.
          mappings = { -- extend mappings
            i = {
              ["<C-q>"] = lga_actions.quote_prompt(),
              ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
            },
          },
          -- ... also accepts theme settings, for example:
          -- theme = "dropdown", -- use dropdown theme
          -- theme = { }, -- use own theme spec
          -- layout_config = { mirror=true }, -- mirror preview pane
        },
      },
    }
  end,
  config = function(_, opts)
    local telescope = require("telescope")
    telescope.setup(opts)
    telescope.load_extension("fzf")
    telescope.load_extension("file_browser")
    telescope.load_extension("live_grep_args")
  end,
}
