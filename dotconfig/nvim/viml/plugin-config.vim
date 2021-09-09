scriptencoding utf-8

let s:script_cwd = expand('<sfile>:p:h')

if len(get(g:, 'plugs_order', [])) !=# 0
  for s:plug in g:plugs_order
    let s:plug_config = s:script_cwd . '/plugins.config/' . s:plug . '.vim'
    if filereadable(s:plug_config)
      execute 'source ' . s:plug_config
    endif
  endfor
endif

" vim-sneak
let g:sneak#label = 1

" committia.vim
let g:committia_min_window_width = 70

if index(get(g:, 'plugs_order', []), 'formatter.nvim') >= 0
  lua require('plugins.formatter')
end

if index(get(g:, 'plugs_order', []), 'gitsigns.nvim') >= 0
  lua require('plugins.gitsigns')
end

if index(get(g:, 'plugs_order', []), 'bufferline.nvim') >= 0
  lua require('plugins.bufferline')
end

if index(get(g:, 'plugs_order', []), 'which-key.nvim') >= 0
  lua require('plugins.which-key')
end
