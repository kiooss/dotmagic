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
    opts.sections.lualine_z = {
      function()
        return " " .. vim.fn["codeium#GetStatusString"]()
      end,
      function()
        return " " .. os.date("%R")
      end,
    }
    opts.extensions = { "nvim-tree", "lazy", "trouble", "symbols-outline" }
  end,
}
