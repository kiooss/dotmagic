return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    local function get_lsp_client()
      local msg = "No Active Lsp"
      local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
      local clients = vim.lsp.get_active_clients()
      if next(clients) == nil then
        return msg
      end

      local lsp_client_names = {}
      for _, client in ipairs(clients) do
        local filetypes = client.config.filetypes
        if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
          table.insert(lsp_client_names, client.name)
        end
      end

      if next(lsp_client_names) == nil then
        return msg
      else
        return " " .. table.concat(lsp_client_names, " ")
      end
    end
    opts.sections.lualine_y = { "encoding", "fileformat", "filetype", { get_lsp_client }, "location", "%L", "progress" }
    opts.extensions = { "nvim-tree", "lazy", "trouble", "symbols-outline" }
  end,
}

-- local M = {
--   "nvim-lualine/lualine.nvim",
--   event = "VeryLazy",
-- }
--
-- local function clock()
--   return " " .. os.date("%H:%M")
-- end
--
-- local function get_lsp_client()
--   local msg = "No Active Lsp"
--   local buf_ft = vim.api.nvim_buf_get_option(0, "filetype")
--   local clients = vim.lsp.get_active_clients()
--   if next(clients) == nil then
--     return msg
--   end
--
--   local lsp_client_names = {}
--   for _, client in ipairs(clients) do
--     local filetypes = client.config.filetypes
--     if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
--       table.insert(lsp_client_names, client.name)
--     end
--   end
--
--   if next(lsp_client_names) == nil then
--     return msg
--   else
--     return " " .. table.concat(lsp_client_names, " ")
--   end
-- end
--
-- function M.config()
--   if vim.g.started_by_firenvim then
--     return
--   end
--
--   require("lualine").setup({
--     options = {
--       theme = "auto",
--       section_separators = { left = "", right = "" },
--       component_separators = { left = "", right = "" },
--       icons_enabled = true,
--       globalstatus = true,
--       disabled_filetypes = { statusline = { "dashboard", "lazy" } },
--     },
--     sections = {
--       lualine_a = { { "mode", separator = { left = "" } } },
--       lualine_b = { "branch" },
--       lualine_c = {
--         { "diagnostics", sources = { "nvim_diagnostic" } },
--         { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
--         { "filename", path = 1, symbols = { modified = "  ", readonly = "", unnamed = "" } },
--         {
--           function()
--             local navic = require("nvim-navic")
--             local ret = navic.get_location()
--             return ret:len() > 2000 and "navic error" or ret
--           end,
--           cond = function()
--             if package.loaded["nvim-navic"] then
--               local navic = require("nvim-navic")
--               return navic.is_available()
--             end
--           end,
--           color = { fg = "#ff9e64" },
--         },
--       },
--       lualine_x = {
--         -- {
--         --   require("noice").api.status.message.get_hl,
--         --   cond = require("noice").api.status.message.has,
--         -- },
--         {
--           function()
--             return require("noice").api.status.command.get()
--           end,
--           cond = function()
--             if package.loaded["noice"] then
--               return require("noice").api.status.command.has()
--             end
--           end,
--           color = { fg = "#ff9e64" },
--         },
--         {
--           function()
--             return require("noice").api.status.mode.get()
--           end,
--           cond = function()
--             if package.loaded["noice"] then
--               return require("noice").api.status.mode.has()
--             end
--           end,
--           color = { fg = "#ff9e64" },
--         },
--         {
--           function()
--             return require("noice").api.status.search.get()
--           end,
--           cond = function()
--             if package.loaded["noice"] then
--               return require("noice").api.status.search.has()
--             end
--           end,
--           color = { fg = "#ff9e64" },
--         },
--         {
--           function()
--             return require("lazy.status").updates()
--           end,
--           cond = require("lazy.status").has_updates,
--           color = { fg = "#ff9e64" },
--         },
--         {
--           function()
--             local stats = require("lazy").stats()
--             local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
--             return " " .. ms .. "ms"
--           end,
--           color = { fg = "#ff9e64" },
--         },
--         -- function()
--         --   return require("messages.view").status
--         -- end,
--         -- {
--         --   function()
--         --     return require("util.dashboard").status()
--         --   end,
--         -- },
--       },
--       lualine_y = { "encoding", "fileformat", "filetype", { get_lsp_client }, "location", "%L", "progress" },
--       lualine_z = { { clock, separator = { right = "" } } },
--     },
--     inactive_sections = {
--       lualine_a = {},
--       lualine_b = {},
--       lualine_c = {},
--       lualine_x = {},
--       lualine_y = {},
--       lualine_z = {},
--     },
--     -- winbar = {
--     --   lualine_a = {},
--     --   lualine_b = {},
--     --   lualine_c = { "filename" },
--     --   lualine_x = {},
--     --   lualine_y = {},
--     --   lualine_z = {},
--     -- },
--     --
--     -- inactive_winbar = {
--     --   lualine_a = {},
--     --   lualine_b = {},
--     --   lualine_c = { "filename" },
--     --   lualine_x = {},
--     --   lualine_y = {},
--     --   lualine_z = {},
--     -- },
--     -- extensions = { "nvim-tree" },
--   })
-- end
--
-- return M
