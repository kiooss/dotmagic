" {{{  coc.nvim config

" use <tab> for trigger completion and navigate to next complete item
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

" for endwise
function! s:SmartCR()
    return "\<CR>" . "\<C-R>=EndwiseDiscretionary()\<CR>"
endfunction

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

" Using CocList
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
" Show all diagnostics
nnoremap <silent> <space>md  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>me  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>mc  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>mo  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>ms  :<C-u>CocList -I symbols<cr>
" Resume CocList
nnoremap <silent> <space>mr  :<C-u>CocListResume<CR>

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K for show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if &filetype == 'vim'
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
vmap ,f  <Plug>(coc-format-selected)
nmap ,f  <Plug>(coc-format-selected)

" Remap for do codeAction of selected region, ex: `,aap` for current paragraph
vmap ,a  <Plug>(coc-codeaction-selected)
nmap ,a  <Plug>(coc-codeaction-selected)
nmap ,ac <Plug>(coc-codeaction)

nmap ,r <Plug>(coc-codelens-action)

" Remap for do codeAction of current line
" nmap <leader>ac  <Plug>(coc-codeaction)

" Fix autofix problem of current line
nmap ,qf  <Plug>(coc-fix-current)

augroup mygroup
  autocmd!
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

function! SetupCommandAbbrs(from, to)
  exec 'cnoreabbrev <expr> '.a:from
        \ .' ((getcmdtype() ==# ":" && getcmdline() ==# "'.a:from.'")'
        \ .'? ("'.a:to.'") : ("'.a:from.'"))'
endfunction

" Use C to open coc config
call SetupCommandAbbrs('C', 'CocConfig')
" }}}
