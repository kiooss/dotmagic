require('nvim-treesitter.configs').setup({
  ensure_installed = {
    'bash',
    'c',
    'cmake',
    'comment',
    'css',
    'scss',
    'dart',
    'dockerfile',
    -- "graphql",
    'html',
    'javascript',
    'json',
    'jsdoc',
    'jsonc',
    'lua',
    'php',
    'python',
    'regex',
    'rust',
    'ruby',
    'toml',
    'tsx',
    'typescript',
    'vue',
    'yaml',
    -- "markdown",
  },
  highlight = { enable = true, additional_vim_regex_highlighting = false },
  indent = { enable = true, disable = { 'yaml' } },
  matchup = {
    enable = true,
    disable = { 'ruby' },
  },
  context_commentstring = {
    enable = true,
    enable_autocmd = false,
    config = {
      -- Languages that have a single comment style
      typescript = { __default = '// %s', __multiline = '/* %s */' },
      css = '/* %s */',
      scss = '/* %s */',
      html = '<!-- %s -->',
      svelte = '<!-- %s -->',
      vue = '<!-- %s -->',
    },
  },
  incremental_selection = {
    enable = false,
    keymaps = {
      init_selection = '<C-n>',
      node_incremental = '<C-n>',
      scope_incremental = '<C-s>',
      node_decremental = '<C-r>',
    },
  },
  query_linter = {
    enable = true,
    use_virtual_text = true,
    lint_events = { 'BufWrite', 'CursorHold' },
  },
  textsubjects = {
    enable = true,
    keymaps = {
      ['.'] = 'textsubjects-smart',
      [';'] = 'textsubjects-container-outer',
    },
  },
  playground = {
    enable = true,
    disable = {},
    updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
    persist_queries = true, -- Whether the query persists across vim sessions
    keybindings = {
      toggle_query_editor = 'o',
      toggle_hl_groups = 'i',
      toggle_injected_languages = 't',
      toggle_anonymous_nodes = 'a',
      toggle_language_display = 'I',
      focus_language = 'f',
      unfocus_language = 'F',
      update = 'R',
      goto_node = '<cr>',
      show_help = '?',
    },
  },
  rainbow = {
    enable = true,
    extended_mode = true, -- Highlight also non-parentheses delimiters, boolean or table: lang -> boolean
    max_file_lines = 1000, -- Do not enable for files with more than 1000 lines, int
    -- colors = {}, -- table of hex strings
    -- termcolors = {} -- table of colour name strings
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = { [']m'] = '@function.outer', [']]'] = '@class.outer' },
      goto_next_end = { [']M'] = '@function.outer', [']['] = '@class.outer' },
      goto_previous_start = { ['[m'] = '@function.outer', ['[['] = '@class.outer' },
      goto_previous_end = { ['[M'] = '@function.outer', ['[]'] = '@class.outer' },
    },
    lsp_interop = {
      enable = true,
      peek_definition_code = {
        ['gD'] = '@function.outer',
      },
    },
  },
})

-- Add Markdown
local parser_config = require('nvim-treesitter.parsers').get_parser_configs()
parser_config.jsonc.filetype_to_parsername = 'json'
parser_config.markdown = {
  install_info = {
    url = 'https://github.com/ikatyang/tree-sitter-markdown',
    files = { 'src/parser.c', 'src/scanner.cc' },
  },
}
