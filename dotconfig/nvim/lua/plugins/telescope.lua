return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      {
        "nvim-telescope/telescope-live-grep-args.nvim",
      },
      { "nvim-telescope/telescope-symbols.nvim" },
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
        "<leader>sv",
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
      { "<leader>tt", "<cmd>Telescope filetypes<cr>", desc = "Filetypes List" },
      { "<M-b>", "<cmd>Telescope buffers<CR>", desc = "Buffers" },
    },
    opts = function(_, opts)
      local actions = require("telescope.actions")
      local open_with_trouble = require("trouble.sources.telescope").open

      local lga_actions = require("telescope-live-grep-args.actions")

      opts.defaults = vim.tbl_deep_extend("force", opts.defaults or {}, {
        winblend = 0,
        -- layout_strategy = "horizontal",
        -- layout_config = {
        --   horizontal = {
        --     prompt_position = "top",
        --     preview_width = 0.5,
        --   },
        --   width = 0.8,
        --   height = 0.8,
        --   preview_cutoff = 120,
        -- },
        -- sorting_strategy = "ascending",
        mappings = {
          i = {
            ["<C-u>"] = false, -- Mapping <C-u> to clear prompt
            ["<c-t>"] = open_with_trouble,
            ["<c-j>"] = actions.move_selection_next,
            ["<c-k>"] = actions.move_selection_previous,
            -- ["<C-Down>"] = actions.cycle_history_next,
            -- ["<C-Up>"] = actions.cycle_history_prev,
            ["<esc>"] = actions.close,
            ["<C-h>"] = actions.which_key,
            ["<C-q>"] = lga_actions.quote_prompt({ postfix = " -t " }),
            ["<C-y>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
          },
          n = {
            ["<c-t>"] = open_with_trouble,
          },
        },
      })
    end,
  },
}
