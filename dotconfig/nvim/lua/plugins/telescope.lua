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
      "<leader>fp",
      function()
        require("telescope.builtin").find_files({
          cwd = require("lazy.core.config").options.root,
        })
      end,
      desc = "Find Plugin File",
    },
  },
  config = function(plugin)
    local actions = require("telescope.actions")
    local trouble = require("trouble.providers.telescope")

    local telescope = require("telescope")
    local borderless = true
    local lga_actions = require("telescope-live-grep-args.actions")

    telescope.setup({
      defaults = {
        -- layout_strategy = 'horizontal',
        -- layout_config = {
        --   prompt_position = 'top',
        -- },
        -- sorting_strategy = 'ascending',
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
        -- vimgrep_arguments = {
        --   'rg',
        --   '--color=never',
        --   '--no-heading',
        --   '--with-filename',
        --   '--line-number',
        --   '--column',
        --   '--smart-case'
        -- },
        -- prompt_position = "bottom",
        prompt_prefix = " ",
        selection_caret = " ",
        -- entry_prefix = "  ",
        -- initial_mode = "insert",
        -- selection_strategy = "reset",
        -- sorting_strategy = "descending",
        -- layout_strategy = "horizontal",
        -- layout_defaults = {
        --   horizontal = {
        --     mirror = false,
        --   },
        --   vertical = {
        --     mirror = false,
        --   },
        -- },
        -- file_sorter = require"telescope.sorters".get_fzy_file
        -- file_ignore_patterns = {},
        -- generic_sorter =  require'telescope.sorters'.get_generic_fuzzy_sorter,
        -- shorten_path = true,
        winblend = borderless and 0 or 10,
        -- width = 0.7,
        -- preview_cutoff = 120,
        -- results_height = 1,
        -- results_width = 0.8,
        -- border = false,
        -- color_devicons = true,
        -- use_less = true,
        -- set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
        -- file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
        -- grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
        -- qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,

        -- -- Developer configurations: Not meant for general override
        -- buffer_previewer_maker = require'telescope.previewers'.buffer_previewer_maker
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
        frecency = {
          show_scores = true,
          default_workspace = "CWD",
        },
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
    })

    -- telescope.load_extension("frecency")
    telescope.load_extension("fzf")
    -- telescope.load_extension('z')
    telescope.load_extension("file_browser")
    telescope.load_extension("live_grep_args")
    -- local telescope = require("telescope")
    -- telescope.setup(vim.tbl_deep_extend("force", plugin._.super.config, {
    --   defaults = {
    --     layout_strategy = "horizontal",
    --     layout_config = { prompt_position = "top" },
    --     sorting_strategy = "ascending",
    --     winblend = 0,
    --   },
    -- }))
    -- telescope.load_extension("fzf")
  end,
}
