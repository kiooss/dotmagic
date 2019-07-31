" ------------------------------------------------
" coc.nvim config
" ------------------------------------------------

" {{{ functions
function! SetupCommandAbbrs(from, to)
  exec 'cnoreabbrev <expr> '.a:from
        \ .' ((getcmdtype() ==# ":" && getcmdline() ==# "'.a:from.'")'
        \ .'? ("'.a:to.'") : ("'.a:from.'"))'
endfunction

" use <tab> for trigger completion and navigate to next complete item
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

" for endwise
function! s:SmartCR()
    return "\<CR>" . "\<C-R>=EndwiseDiscretionary()\<CR>"
endfunction

function! s:GrepFromSelected(type)
  let saved_unnamed_register = @@
  if a:type ==# 'v'
    normal! `<v`>y
  elseif a:type ==# 'char'
    normal! `[v`]y
  else
    return
  endif
  let word = substitute(@@, '\n$', '', 'g')
  let word = escape(word, '| ')
  let @@ = saved_unnamed_register
  execute 'CocList grep '.word
endfunction

function! s:show_documentation()
  if &filetype == 'vim'
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" }}}

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<CR>"
inoremap <silent><expr> <cr> pumvisible() ? "\<C-y>" : <SID>SmartCR()

" Use <C-j> to trigger snippet expand.
imap <C-j> <Plug>(coc-snippets-expand)

" Use <c-g> for trigger completion.
inoremap <silent><expr> <c-g> coc#refresh()

" Use `[d` and `]d` for navigate diagnostics
nmap <silent> [d <Plug>(coc-diagnostic-prev)
nmap <silent> ]d <Plug>(coc-diagnostic-next)

" CocList
nnoremap <leader>ma  :<C-u>CocList<space>
" Show all diagnostics
nnoremap <silent> <leader>md  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <leader>me  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <leader>mc  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <leader>mo  :<C-u>CocList outline<cr>
" mru
nnoremap <silent> <leader>mm :<C-u>CocList mru<cr>
" files
nnoremap <silent> <leader>mf :<C-u>CocList files<cr>
" words
nnoremap <silent> <leader>mw :<C-u>CocList words<cr>
" Search workspace symbols
nnoremap <silent> <leader>ms  :<C-u>CocList -I symbols<cr>
" Resume latest coc list
nnoremap <silent> <leader>mr  :<C-u>CocListResume<cr>
" yank
nnoremap <silent> <leader>my  :<C-u>CocList -A --normal yank<cr>

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> gt <Plug>(coc-translator-p)

" Use K for show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)
nmap <leader>rf <Plug>(coc-refactor)
nmap <leader>ca <Plug>(coc-codelens-action)

" Remap for format selected region
vmap \f  <Plug>(coc-format-selected)
nmap \f  <Plug>(coc-format-selected)

" Remap for do codeAction of selected region, ex: `,aap` for current paragraph
xmap <leader>ac  <Plug>(coc-codeaction-selected)
nmap <leader>ac  <Plug>(coc-codeaction)

" Fix autofix problem of current line
nmap \q  <Plug>(coc-fix-current)

vnoremap \g :<C-u>call <SID>GrepFromSelected(visualmode())<CR>
nnoremap \g :<C-u>set operatorfunc=<SID>GrepFromSelected<CR>g@

augroup MyAutoCmd
  " Highlight symbol under cursor on CursorHold
  autocmd CursorHold * silent call CocActionAsync('highlight')
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')

  autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif
augroup end

command! -nargs=0 Prettier :CocCommand prettier.formatFile

" Use `:Format` for format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` for fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Use C to open coc config
call SetupCommandAbbrs('C', 'CocConfig')

" vim: set ts=2 sw=2 tw=80 fdl=0 et :
