local packer = require("util.packer")
local global = require("core.global")

local config = {
  profile = {
    enable = false,
    threshold = 0, -- the amount in ms that a plugins load time must be over for it to be included in the profile
  },
  display = {
    open_fn = function()
      return require("packer.util").float({ border = "single" })
    end,
  },
  -- list of plugins that should be taken from ~/projects
  -- this is NOT packer functionality!
  local_plugins = {},
}

local function plugins(use)
  -- Packer can manage itself as an optional plugin
  use({ "wbthomason/packer.nvim", opt = true })
  -- use({"folke/workspace.nvim"})

  use({
    "neoclide/coc.nvim",
    disable = true,
    branch = "release",
    config = function()
      vim.cmd("source ~/.config/nvim/viml/plugins.config/coc.nvim.vim")
    end,
  })

  -- LSP related plugins start
  use({
    "neovim/nvim-lspconfig",
    opt = true,
    event = "BufReadPre",
    wants = {
      -- "nvim-lsp-ts-utils",
      "null-ls.nvim",
      "lua-dev.nvim",
    },
    config = function()
      require("config.lsp")
    end,
    requires = {
      -- "jose-elias-alvarez/nvim-lsp-ts-utils",
      "jose-elias-alvarez/null-ls.nvim",
      "folke/lua-dev.nvim",
    },
  })

  use({
    "RRethy/vim-illuminate",
    event = "CursorHold",
    module = "illuminate",
    config = function()
      vim.g.Illuminate_delay = 100
    end,
  })
  -- LSP related plugins end

  use({
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    config = function()
      require("config.nvim-cmp")
    end,
    requires = {
      "onsails/lspkind-nvim",
      "hrsh7th/cmp-nvim-lsp",
      { "hrsh7th/cmp-buffer", after = "nvim-cmp" },
      { "hrsh7th/cmp-vsnip", after = "nvim-cmp" },
      { "hrsh7th/cmp-path", after = "nvim-cmp" },
      { "hrsh7th/cmp-nvim-lua", after = "nvim-cmp" },
      { "octaltree/cmp-look", after = "nvim-cmp" },
      {
        "windwp/nvim-autopairs",
        after = "nvim-cmp",
        config = function()
          require("config.autopairs")
        end,
      },
      { "hrsh7th/vim-vsnip", after = "nvim-cmp" },
      { "hrsh7th/vim-vsnip-integ", after = "nvim-cmp" },
      { "rafamadriz/friendly-snippets", after = "vim-vsnip" },
    },
  })

  -- use(
  --   {
  --     "hrsh7th/nvim-compe",
  --     event = "InsertEnter",
  --     opt = true,
  --     config = function()
  --       require("config.compe")
  --     end,
  --     wants = {"LuaSnip"},
  --     requires = {
  --       {
  --         "L3MON4D3/LuaSnip",
  --         wants = "friendly-snippets",
  --         config = function()
  --           require("config.snippets")
  --         end
  --       },
  --       "rafamadriz/friendly-snippets",
  --       {
  --         "windwp/nvim-autopairs",
  --         config = function()
  --           require("config.autopairs")
  --         end
  --       }
  --     }
  --   }
  -- )

  -- use(
  --   {
  --     "simrat39/symbols-outline.nvim",
  --     cmd = {"SymbolsOutline"}
  --   }
  -- )

  use({
    "b3nj5m1n/kommentary",
    opt = true,
    wants = "nvim-ts-context-commentstring",
    keys = { "gc", "gcc" },
    config = function()
      require("config.comments")
    end,
    requires = "JoosepAlviste/nvim-ts-context-commentstring",
  })

  use({
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    opt = true,
    event = "BufRead",
    requires = {
      { "nvim-treesitter/playground", cmd = "TSHighlightCapturesUnderCursor" },
      "nvim-treesitter/nvim-treesitter-textobjects",
      "p00f/nvim-ts-rainbow",
      "RRethy/nvim-treesitter-textsubjects",
    },
    config = [[require('config.treesitter')]],
  })

  use({
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("config.colorizer")
    end,
  })

  -- Theme: color schemes
  -- use("tjdevries/colorbuddy.vim")
  use({
    -- "shaunsingh/nord.nvim",
    -- "shaunsingh/moonlight.nvim",
    -- { "olimorris/onedark.nvim", requires = "rktjmp/lush.nvim" },
    -- "joshdick/onedark.vim",
    -- "wadackel/vim-dogrun",
    -- { "npxbr/gruvbox.nvim", requires = "rktjmp/lush.nvim" },
    -- "bluz71/vim-nightfly-guicolors",
    -- { "marko-cerovac/material.nvim" },
    -- "sainnhe/edge",
    -- { "embark-theme/vim", as = "embark" },
    -- "norcalli/nvim-base16.lua",
    -- "RRethy/nvim-base16",
    -- "novakne/kosmikoa.nvim",
    -- "glepnir/zephyr-nvim",
    -- "ghifarit53/tokyonight-vim"
    -- "sainnhe/sonokai",
    -- "morhetz/gruvbox",
    -- "arcticicestudio/nord-vim",
    -- "drewtempelmeyer/palenight.vim",
    -- "Th3Whit3Wolf/onebuddy",
    -- "christianchiarulli/nvcode-color-schemes.vim",
    -- "Th3Whit3Wolf/one-nvim"

    -- "folke/tokyonight.nvim",
    "rose-pine/neovim",
    -- "glepnir/zephyr-nvim",
    config = function()
      -- require("config.theme")
      -- Set variant
      -- Defaults to 'dawn' if vim background is light
      -- @usage 'base' | 'moon' | 'dawn' | 'rose-pine[-moon][-dawn]'
      vim.g.rose_pine_variant = "rose-pine-moon"
      -- Disable italics
      vim.g.rose_pine_disable_italics = false
      -- Use terminal background
      vim.g.rose_pine_disable_background = false
    end,
  })

  use({
    "folke/tokyonight.nvim",
    config = function()
      require("config.theme")
    end,
  })

  use({
    "sainnhe/everforest",
    config = function()
      vim.g.everforest_background = "soft"
      vim.g.everforest_enable_italic = 1
      vim.g.everforest_diagnostic_text_highlight = 1
    end,
  })

  -- Theme: icons
  use({
    "kyazdani42/nvim-web-devicons",
    module = "nvim-web-devicons",
    config = function()
      require("nvim-web-devicons").setup({ default = true })
    end,
  })

  -- Dashboard
  use({ "glepnir/dashboard-nvim", config = [[require('config.dashboard')]] })

  use({
    "norcalli/nvim-terminal.lua",
    ft = "terminal",
    config = function()
      require("terminal").setup()
    end,
  })
  use({ "nvim-lua/plenary.nvim", module = "plenary" })
  use({ "nvim-lua/popup.nvim", module = "popup" })

  -- use(
  --   {
  --     "windwp/nvim-spectre",
  --     opt = true,
  --     module = "spectre",
  --     wants = {"plenary.nvim", "popup.nvim"},
  --     requires = {"nvim-lua/popup.nvim", "nvim-lua/plenary.nvim"}
  --   }
  -- )

  -- file explorer
  use({
    "kyazdani42/nvim-tree.lua",
    config = function()
      require("config.tree")
    end,
  })

  use({
    "mhartington/formatter.nvim",
    cmd = { "Format", "FormatWrite" },
    config = function()
      require("config.formatter")
    end,
  })

  -- Fuzzy finder
  use({
    "nvim-telescope/telescope.nvim",
    opt = true,
    config = function()
      require("config.telescope")
    end,
    cmd = { "Telescope" },
    module = "telescope",
    keys = { "<leader><space>", "<leader>fd", "<leader>pp" },
    wants = {
      "plenary.nvim",
      "popup.nvim",
      "telescope-z.nvim",
      -- "telescope-frecency.nvim",
      "telescope-fzy-native.nvim",
      "telescope-project.nvim",
      "trouble.nvim",
      "telescope-symbols.nvim",
    },
    requires = {
      "nvim-telescope/telescope-z.nvim",
      "nvim-telescope/telescope-project.nvim",
      "nvim-lua/popup.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-symbols.nvim",
      "nvim-telescope/telescope-fzy-native.nvim",
      -- { "nvim-telescope/telescope-frecency.nvim", requires = "tami5/sql.nvim" }
    },
  })

  use({
    "sudormrfbin/cheatsheet.nvim",
    -- requires = {
    --   { "nvim-telescope/telescope.nvim" },
    --   { "nvim-lua/popup.nvim" },
    --   { "nvim-lua/plenary.nvim" },
    -- },
    config = function()
      require("cheatsheet").setup({
        bundled_cheatsheets = true,
        bundled_plugin_cheatsheets = true,
        include_only_installed_plugins = true,
      })
    end,
  })

  -- Indent Guides and rainbow brackets
  use({
    "lukas-reineke/indent-blankline.nvim",
    event = "BufReadPre",
    config = function()
      require("config.indent-blankline")
    end,
  })

  -- Tabs
  use({
    "akinsho/nvim-bufferline.lua",
    event = "BufReadPre",
    wants = "nvim-web-devicons",
    config = function()
      require("config.bufferline")
    end,
  })

  -- Terminal
  -- use(
  --   {
  --     "akinsho/nvim-toggleterm.lua",
  --     keys = "<M-`>",
  --     config = function()
  --       require("config.terminal")
  --     end
  --   }
  -- )

  -- Smooth Scrolling
  use({
    "karb94/neoscroll.nvim",
    keys = { "<C-u>", "<C-d>", "gg", "G" },
    config = function()
      require("config.scroll")
    end,
  })

  -- use(
  --   {
  --     "edluffy/specs.nvim",
  --     after = "neoscroll.nvim",
  --     config = function()
  --       require("config.specs")
  --     end
  --   }
  -- )
  -- use { "Xuyuanp/scrollbar.nvim", config = function() require("config.scrollbar") end }

  -- Git Gutter
  use({
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    wants = "plenary.nvim",
    requires = { "nvim-lua/plenary.nvim" },
    config = function()
      require("config.gitsigns")
    end,
  })
  -- use {
  --   "kdheepak/lazygit.nvim",
  --   cmd = "LazyGit",
  --   config = function() vim.g.lazygit_floating_window_use_plenary = 0 end
  -- }
  use({
    "TimUntersberger/neogit",
    cmd = "Neogit",
    config = function()
      require("config.neogit")
    end,
  })

  -- Statusline
  use({
    "hoob3rt/lualine.nvim",
    disable = true,
    event = "VimEnter",
    config = [[require('config.lualine')]],
    wants = "nvim-web-devicons",
  })

  use({
    "glepnir/galaxyline.nvim",
    config = function()
      require("config.galaxyline")
    end,
    requires = { "kyazdani42/nvim-web-devicons", opt = true },
  })
  -- use(
  --   {
  --     "norcalli/nvim-colorizer.lua",
  --     event = "BufReadPre",
  --     config = function()
  --       require("config.colorizer")
  --     end
  --   }
  -- )

  -- use({"npxbr/glow.nvim", cmd = "Glow"})

  use({
    "plasticboy/vim-markdown",
    opt = true,
    requires = "godlygeek/tabular",
    ft = "markdown",
  })
  use({
    "iamcco/markdown-preview.nvim",
    run = function()
      vim.fn["mkdp#util#install"]()
    end,
    ft = "markdown",
    cmd = { "MarkdownPreview" },
  })

  -- use { "tjdevries/train.nvim", cmd = { "TrainClear", "TrainTextObj", "TrainUpDown", "TrainWord" } }

  -- use({ "wfxr/minimap.vim", config = function()
  --   require("config.minimap")
  -- end })

  -- use(
  --   {
  --     "phaazon/hop.nvim",
  --     keys = {"gh"},
  --     cmd = {"HopWord", "HopChar1"},
  --     config = function()
  --       require("util").nmap("gh", "<cmd>HopWord<CR>")
  --       -- require("util").nmap("s", "<cmd>HopChar1<CR>")
  --       -- you can configure Hop the way you like here; see :h hop-config
  --       require("hop").setup({})
  --     end
  --   }
  -- )

  -- use(
  --   {
  --     "ggandor/lightspeed.nvim",
  --     event = "BufReadPost",
  --     config = function()
  --       require("config.lightspeed")
  --     end
  --   }
  -- )

  use({
    "folke/trouble.nvim",
    event = "BufReadPre",
    wants = "nvim-web-devicons",
    cmd = { "TroubleToggle", "Trouble" },
    config = function()
      require("trouble").setup({ auto_open = false })
    end,
  })

  -- use(
  --   {
  --     "folke/persistence.nvim",
  --     event = "BufReadPre",
  --     module = "persistence",
  --     config = function()
  --       require("persistence").setup()
  --     end
  --   }
  -- )

  use({ "tweekmonster/startuptime.vim", cmd = "StartupTime" })

  use({ "mbbill/undotree", cmd = "UndotreeToggle" })

  -- use(
  --   {
  --     "folke/zen-mode.nvim",
  --     cmd = "ZenMode",
  --     opt = true,
  --     wants = "twilight.nvim",
  --     requires = {"folke/twilight.nvim"},
  --     config = function()
  --       require("zen-mode").setup(
  --         {
  --           plugins = {gitsigns = true, tmux = true, kitty = {enabled = false, font = "+2"}}
  --         }
  --       )
  --     end
  --   }
  -- )

  use({
    "folke/todo-comments.nvim",
    cmd = { "TodoTrouble", "TodoTelescope" },
    event = "BufReadPost",
    config = function()
      require("config.todo-comments")
    end,
  })

  use({
    "folke/which-key.nvim",
    event = "VimEnter",
    config = function()
      require("config.keys")
    end,
  })

  use({
    "sindrets/diffview.nvim",
    cmd = {
      "DiffviewOpen",
      "DiffviewClose",
      "DiffviewToggleFiles",
      "DiffviewFocusFiles",
    },
    config = function()
      require("config.diffview")
    end,
  })

  -- use({ "wellle/targets.vim" })

  -- use("DanilaMihailov/vim-tips-wiki")
  -- use("nanotee/luv-vimdocs")
  use({
    "andymass/vim-matchup",
    event = "CursorMoved",
  })
  -- use({"camspiers/snap", rocks = {"fzy"}, module = "snap"})
  -- use("kmonad/kmonad-vim")

  use({
    "tpope/vim-endwise",
    config = function()
      vim.g.endwise_no_mappings = 1
    end,
  })

  use({ "mhinz/vim-sayonara", cmd = { "Sayonara" } })

  use({ "AndrewRadev/switch.vim" })

  use({ "kiooss/vim-zenkaku-space" })

  use({
    "jghauser/mkdir.nvim",
    config = function()
      require("mkdir")
    end,
  })

  use({
    "lambdalisue/suda.vim",
  })

  use({
    "pechorin/any-jump.vim",
  })

  use({
    "rhysd/committia.vim",
  })

  use({
    "mattn/vim-sqlfmt",
    ft = "sql",
  })

  if global.is_linux then
    use({
      "wincent/vim-clipper",
      setup = function()
        vim.g.ClipperMap = 0
        vim.g.ClipperAddress = "~/.clipper.sock"
        vim.g.ClipperPort = 0
      end,
    })
  end

  use({ "junegunn/vim-easy-align" })
  use({ "kana/vim-textobj-entire" })
  use({ "kana/vim-textobj-function" })
  use({ "kana/vim-textobj-user" })
  use({ "nelstrom/vim-textobj-rubyblock" })
  use({ "thalesmello/vim-textobj-methodcall" })
  use({ "tpope/vim-repeat" })
  use({
    "tpope/vim-surround",
    config = function()
      vim.g.surround_no_insert_mappings = 1
    end,
  })
  use({ "wellle/targets.vim" })

  -- use({
  --   "SirVer/ultisnips",
  --   setup = function()
  --     vim.g.UltiSnipsExpandTrigger = "<c-k>"
  --     vim.g.UltiSnipsJumpForwardTrigger = "<c-k>"
  --     vim.g.UltiSnipsJumpBackwardTrigger = "<c-j>"
  --     vim.g.UltiSnipsEditSplit = "vertical"
  --     vim.g.UltiSnipsSnippetDirectories = { "UltiSnips" }
  --   end,
  -- })
  use({ "honza/vim-snippets" })
  use({ "algotech/ultisnips-php" })
  use({ "epilande/vim-react-snippets" })
  use({ "famiu/bufdelete.nvim", cmd = "Bdelete" })
  use({ "editorconfig/editorconfig-vim" })

  use({
    "vimwiki/vimwiki",
    opt = true,
    cmd = "VimwikiIndex",
    keys = { "<leader>W" },
    setup = function()
      vim.g.vimwiki_list = {
        { path = "~/vimwiki/", syntax = "markdown", ext = ".md" },
      }
      vim.g.vimwiki_conceallevel = 0
      vim.g.vimwiki_use_calendar = 1
      vim.g.vimwiki_hl_headers = 1
      vim.g.vimwiki_hl_cb_checked = 1
      vim.g.vimwiki_autowriteall = 0
      vim.g.vimwiki_map_prefix = "<F12>"
      vim.g.vimwiki_table_mappings = 0
    end,
  })

  use({ "mg979/vim-visual-multi" })

  -- Syntax plugins
  use({ "lumiliet/vim-twig", ft = "twig" })
end

return packer.setup(config, plugins)
