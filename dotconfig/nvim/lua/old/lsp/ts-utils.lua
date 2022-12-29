return {
  setup = function(client)
    local ts = require('nvim-lsp-ts-utils')
    -- vim.lsp.handlers["textDocument/codeAction"] = ts.code_action_handler
    ts.setup({
      disable_commands = false,
      enable_import_on_completion = false,
      import_on_completion_timeout = 5000,
    })

    ts.setup_client(client)
  end,
}
