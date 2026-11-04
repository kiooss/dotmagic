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
        "blade",
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
      -- nvim-treesitter main branch: incremental_selection / query_linter / highlight
      -- modules no longer exist. For node selection use LazyVim's `S` (Flash Treesitter).
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      { "windwp/nvim-ts-autotag", opts = {} },
    },
  },
}
