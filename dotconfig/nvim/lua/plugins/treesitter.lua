return {
  { "nvim-treesitter/playground", cmd = "TSPlaygroundToggle" },

  {
    "mfussenegger/nvim-treehopper",
    keys = { { "m", mode = { "o", "x" } } },
    config = function()
      vim.cmd([[
        omap     <silent> m :<C-U>lua require('tsht').nodes()<CR>
        xnoremap <silent> m :lua require('tsht').nodes()<CR>
      ]])
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "User LazyFile",
    enabled = true,
    opts = { mode = "cursor" },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash",
        "c",
        "cmake",
        "cpp",
        "css",
        "diff",
        "fish",
        "gitignore",
        "go",
        "graphql",
        "html",
        "http",
        "java",
        "javascript",
        "jsdoc",
        "lua",
        "markdown",
        "markdown_inline",
        "php",
        "python",
        "query",
        "regex",
        "ruby",
        "rust",
        "scss",
        "sql",
        "toml",
        "tsx",
        "twig",
        "typescript",
        "vhs",
        "vim",
        "vue",
        "yaml",
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-m>",
          node_incremental = "<C-m>",
          scope_incremental = "<nop>",
          node_decremental = "<bs>",
        },
      },
      query_linter = {
        enable = true,
        use_virtual_text = true,
        lint_events = { "BufWrite", "CursorHold" },
      },
      highlight = { enable = true },
      -- playground = {
      --   enable = true,
      --   disable = {},
      --   updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
      --   persist_queries = true, -- Whether the query persists across vim sessions
      --   keybindings = {
      --     toggle_query_editor = "o",
      --     toggle_hl_groups = "i",
      --     toggle_injected_languages = "t",
      --     toggle_anonymous_nodes = "a",
      --     toggle_language_display = "I",
      --     focus_language = "f",
      --     unfocus_language = "F",
      --     update = "R",
      --     goto_node = "<cr>",
      --     show_help = "?",
      --   },
      -- },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      { "windwp/nvim-ts-autotag", opts = {} },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      { "EmranMR/tree-sitter-blade" },
    },
    opts = function(_, opts)
      ---@diagnostic disable-next-line: inject-field
      require("nvim-treesitter.parsers").get_parser_configs().blade = {
        install_info = {
          url = "https://github.com/EmranMR/tree-sitter-blade",
          files = { "src/parser.c" },
          branch = "main",
        },
        filetype = "blade",
      }
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "blade" })
      end
    end,
  },
}
