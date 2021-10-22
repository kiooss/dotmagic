local M = {}

function M.edit_neovim()
  local opts_with_preview, opts_without_preview

  local action_state = require('telescope.actions.state')
  local actions = require('telescope.actions')

  local set_prompt_to_entry_value = function(prompt_bufnr)
    local entry = action_state.get_selected_entry()
    if not entry or not type(entry) == 'table' then
      return
    end

    action_state.get_current_picker(prompt_bufnr):reset_prompt(entry.ordinal)
  end

  opts_with_preview = {
    prompt_title = '~ neovim config ~',
    shorten_path = false,
    cwd = '~/.config/nvim',

    layout_strategy = 'flex',
    layout_config = {
      width = 0.9,
      height = 0.8,

      horizontal = {
        width = { padding = 0.15 },
      },
      vertical = {
        preview_height = 0.75,
      },
    },

    attach_mappings = function(_, map)
      map('i', '<c-y>', set_prompt_to_entry_value)
      map('i', '<M-c>', function(prompt_bufnr)
        actions.close(prompt_bufnr)
        vim.schedule(function()
          require('telescope.builtin').find_files(opts_without_preview)
        end)
      end)

      return true
    end,
  }

  opts_without_preview = vim.deepcopy(opts_with_preview)
  opts_without_preview.previewer = false

  require('telescope.builtin').find_files(opts_with_preview)
end

function M.dotfiles()
  require('telescope.builtin').git_files({
    prompt_title = '~ dotfiles ~',
    cwd = '~/.dotfiles',
  })
end

function M.oldfiles_cwd_only()
  require('telescope.builtin').oldfiles({
    prompt_title = '~ Oldfiles (cwd: ' .. vim.loop.cwd() .. ')~',
    cwd_only = true,
  })
end

function M.project_files(opts)
  opts = opts or {}

  local _git_pwd = vim.fn.systemlist('git rev-parse --show-toplevel')[1]

  if vim.v.shell_error ~= 0 then
    local client = vim.lsp.get_active_clients()[1]
    if client then
      opts.cwd = client.config.root_dir
    end
    require('telescope.builtin').find_files(opts)
    return
  end

  require('telescope.builtin').git_files(opts)
end

function M.frecency_files()
  require('telescope').extensions.frecency.frecency()
end

function M.notify()
  require('telescope').extensions.notify.notify({
    previewer = false,
  })
end

function M.projects()
  require('telescope').extensions.project.project()
end

function M.curbuf()
  local themes = require('telescope.themes')
  local opts = themes.get_dropdown({
    winblend = 10,
    border = true,
    previewer = false,
    shorten_path = false,
  })
  require('telescope.builtin').current_buffer_fuzzy_find(opts)
end

function M.lsp_code_actions()
  local themes = require('telescope.themes')
  local opts = themes.get_cursor({
    winblend = 10,
    border = true,
  })

  require('telescope.builtin').lsp_code_actions(opts)
end

return M
