return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    local function get_lsp_client()
      local msg = "No Active Lsp"
      local buf_ft = vim.bo.filetype
      local lsp_client_names = {}
      for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
        local filetypes = client.config.filetypes
        if filetypes and vim.tbl_contains(filetypes, buf_ft) then
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
        return " " .. os.date("%R")
      end,
    }
    opts.extensions = { "nvim-tree", "lazy", "trouble", "symbols-outline" }
  end,
}
