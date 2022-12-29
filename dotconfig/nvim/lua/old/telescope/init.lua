-- local trouble = require('trouble.providers.telescope')
local telescope = require('telescope')
local actions = require('telescope.actions')

telescope.setup({
  defaults = {
    -- layout_strategy = 'horizontal',
    -- layout_config = {
    --   width = 0.95,
    --   height = 0.85,
    --   -- preview_cutoff = 120,
    --   prompt_position = 'top',

    --   horizontal = {
    --     preview_width = function(_, cols, _)
    --       if cols > 200 then
    --         return math.floor(cols * 0.4)
    --       else
    --         return math.floor(cols * 0.6)
    --       end
    --     end,
    --   },

    --   vertical = {
    --     width = 0.9,
    --     height = 0.95,
    --     preview_height = 0.5,
    --   },

    --   flex = {
    --     horizontal = {
    --       preview_width = 0.9,
    --     },
    --   },
    -- },
    mappings = {
      i = {
        -- To disable a keymap, put [map] = false
        -- So, to not map "<C-n>", just put
        -- ['<c-t>'] = trouble.open_with_trouble,
        ['<c-j>'] = actions.move_selection_next,
        ['<c-k>'] = actions.move_selection_previous,
        -- Otherwise, just set the mapping to the function that you want it to be.
        -- ["<C-i>"] = actions.select_horizontal,
        -- Add up multiple actions
        -- ["<cr>"] = actions.select_default + actions.center,
        ['<esc>'] = actions.close,
        ['<C-h>'] = actions.which_key,
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
    frecency = {
      show_scores = true,
      default_workspace = 'CWD',
    },
  },
})

-- telescope.load_extension('fzy_native')
telescope.load_extension('fzf')
telescope.load_extension('frecency')
-- telescope.load_extension("z")
telescope.load_extension('project')
telescope.load_extension('file_browser')
telescope.load_extension('notify')
telescope.load_extension('flutter')

vim.cmd([[autocmd User TelescopePreviewerLoaded setlocal wrap]])
