local trouble = require('trouble.providers.telescope')

local telescope = require('telescope')
local actions = require('telescope.actions')
local themes = require('telescope.themes')

telescope.setup({
  defaults = {
    mappings = {
      i = {
        -- To disable a keymap, put [map] = false
        -- So, to not map "<C-n>", just put
        ['<c-t>'] = trouble.open_with_trouble,
        ['<c-j>'] = actions.move_selection_next,
        ['<c-k>'] = actions.move_selection_previous,
        -- Otherwise, just set the mapping to the function that you want it to be.
        -- ["<C-i>"] = actions.select_horizontal,
        -- Add up multiple actions
        -- ["<cr>"] = actions.select_default + actions.center,
        ['<esc>'] = actions.close,
      },
      n = {
        ['<esc>'] = actions.close,
      },
    },
    -- vimgrep_arguments = {
    --   'rg',
    --   '--color=never',
    --   '--no-heading',
    --   '--with-filename',
    --   '--line-number',
    --   '--column',
    --   '--smart-case'
    -- },
    -- prompt_position = "bottom",
    prompt_prefix = ' ',
    selection_caret = ' ',
    -- entry_prefix = "  ",
    -- initial_mode = "insert",
    -- selection_strategy = "reset",
    -- sorting_strategy = "descending",
    -- layout_strategy = "horizontal",
    -- layout_defaults = {
    --   horizontal = {
    --     mirror = false,
    --   },
    --   vertical = {
    --     mirror = false,
    --   },
    -- },
    -- file_sorter = require"telescope.sorters".get_fzy_file
    -- file_ignore_patterns = {},
    -- generic_sorter =  require'telescope.sorters'.get_generic_fuzzy_sorter,
    -- shorten_path = true,
    winblend = 10,
    -- width = 0.7,
    -- preview_cutoff = 120,
    -- results_height = 1,
    -- results_width = 0.8,
    -- border = {},
    -- borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
    -- borderchars = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
    -- prompt = { "─", "│", " ", "│", "┌", "┐", "│", "│" },
    -- results = { "─", "│", "─", "│", "├", "┤", "┘", "└" },
    -- preview = { "─", "│", "─", "│", "┌", "┐", "┘", "└" }
    -- color_devicons = true,
    -- use_less = true,
    -- set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
    -- file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
    -- grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
    -- qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,

    -- -- Developer configurations: Not meant for general override
    -- buffer_previewer_maker = require'telescope.previewers'.buffer_previewer_maker
  },
  extensions = {
    -- fzy_native = { override_generic_sorter = false, override_file_sorter = true },
    fzf = {
      fuzzy = true, -- false will only do exact matching
      override_generic_sorter = true, -- override the generic sorter
      override_file_sorter = true, -- override the file sorter
      case_mode = 'smart_case', -- or "ignore_case" or "respect_case"
      -- the default case_mode is "smart_case"
    },
  },
})

-- telescope.load_extension("frecency")
-- telescope.load_extension('fzy_native')
telescope.load_extension('fzf')
telescope.load_extension('frecency')
-- telescope.load_extension("z")
telescope.load_extension('project')

local M = {}

M.project_files = function(opts)
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

function M.curbuf()
  local opts = themes.get_dropdown({
    winblend = 10,
    border = true,
    previewer = false,
    shorten_path = false,
  })
  require('telescope.builtin').current_buffer_fuzzy_find(opts)
end

function M.lsp_code_actions()
  local opts = themes.get_cursor({
    winblend = 10,
    border = true,
  })

  require('telescope.builtin').lsp_code_actions(opts)
end

-- mappings
local util = require('util')

util.nnoremap('<Leader><Space>', M.project_files)
util.nnoremap('<Leader>ff', M.frecency_files)
util.nnoremap('<Leader>fd', function()
  require('telescope.builtin').git_files({ cwd = '~/.dotfiles' })
end)
util.nnoremap('<Leader>fr', function()
  require('telescope.builtin').oldfiles({ cwd_only = true })
end)
util.nnoremap('/', M.curbuf)

-- util.nnoremap(
--   "<leader>fz",
--   function()
--     require("telescope").extensions.z.list({cmd = {vim.o.shell, "-c", "zoxide query -ls"}})
--   end
-- )

util.nnoremap('<leader>fp', ":lua require'telescope'.extensions.project.project{}<CR>")

return M
