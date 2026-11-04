return {
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = false, -- Never set this value to "*"! Never!
    ---@module 'avante'
    ---@type avante.Config
    opts = {
      -- add any opts here
      -- for example
      -- provider = "openai",
      -- openai = {
      --   endpoint = "https://api.openai.com/v1",
      --   model = "gpt-4o", -- your desired model (or use gpt-4o, etc.)
      --   timeout = 30000, -- timeout in milliseconds
      --   temperature = 0, -- adjust if needed
      --   max_tokens = 4096,
      -- },
      -- provider = "deepseek",
      provider = "gemini-cli",
      -- provider = "gemini",
      providers = {
        deepseek = {
          __inherited_from = "openai",
          -- api_key_name = "cmd:bw get notes anthropic-api-key",
          api_key_name = "DEEPSEEK_API_KEY",
          endpoint = "https://api.deepseek.com",
          model = "deepseek-chat",
          max_tokens = 8192,
        },
      },
      -- acp_providers = {
      --   ["gemini-cli"] = {
      --     command = "gemini",
      --     args = { "--experimental-acp" },
      --     env = {
      --       NODE_NO_WARNINGS = "1",
      --       GEMINI_API_KEY = os.getenv("AVANTE_GEMINI_API_KEY"),
      --     },
      --   },
      -- },
      --
      -- provider = "deepseek",
      -- vendors = {
      --   deepseek = {
      --     __inherited_from = "openai",
      --     -- api_key_name = "cmd:bw get notes anthropic-api-key",
      --     api_key_name = "DEEPSEEK_API_KEY",
      --     endpoint = "https://api.scnet.cn/api/llm/v1",
      --     model = "DeepSeek-R1-Distill-Qwen-32B",
      --   },
      -- },
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      { "ColinKennedy/mega.cmdparse", dependencies = { "ColinKennedy/mega.logging" } },
      --- The below dependencies are optional.
      -- selector/input default to "native", i.e. vim.ui.select (LazyVim's picker, fzf-lua here)
      -- and vim.ui.input (Snacks), so the mini.pick / telescope / dressing providers aren't needed.
      "folke/snacks.nvim",
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      "zbirenbaum/copilot.lua", -- for providers='copilot'
      {
        -- support for image pasting
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
  },
}
