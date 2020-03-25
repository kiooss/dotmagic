" ------------------------------------------------
" coc.nvim config
" ------------------------------------------------
let g:coc_global_extensions = [
  \ 'coc-css',
  \ 'coc-dictionary',
  \ 'coc-docker',
  \ 'coc-emoji',
  \ 'coc-eslint',
  \ 'coc-git',
  \ 'coc-gitignore',
  \ 'coc-highlight',
  \ 'coc-html',
  \ 'coc-json',
  \ 'coc-lists',
  \ 'coc-marketplace',
  \ 'coc-markdownlint',
  \ 'coc-omni',
  \ 'coc-pairs',
  \ 'coc-phpls',
  \ 'coc-post',
  \ 'coc-prettier',
  \ 'coc-snippets',
  \ 'coc-solargraph',
  \ 'coc-sql',
  \ 'coc-stylelint',
  \ 'coc-translator',
  \ 'coc-tsserver',
  \ 'coc-ultisnips',
  \ 'coc-vetur',
  \ 'coc-word',
  \ 'coc-yaml',
  \ 'coc-yank',
  \ ]
  " \ 'coc-tabnine',

" functions {{{
function! StatusDiagnostic() abort
  let info = get(b:, 'coc_diagnostic_info', {})
  if empty(info) | return '' | endif
  let msgs = []
  if get(info, 'error', 0)
    call add(msgs, '✗:' . info['error'])
  endif
  if get(info, 'warning', 0)
    call add(msgs, '⚠ :' . info['warning'])
  endif
  if get(info, 'information', 0)
    call add(msgs, 'ℹ:' . info['information'])
  endif
  if get(info, 'hint', 0)
    call add(msgs, "\ufaa5:" . info['hint'])
  endif
  return join(msgs, ' '). ' ' . get(g:, 'coc_status', '')
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
  execute 'CocList --normal grep '.word
endfunction

function! s:show_documentation()
  if &filetype == 'vim'
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" }}}
" mappings {{{
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
nnoremap <leader>l  :<C-u>CocList<space>
nnoremap <leader>S  :<C-u>CocSearch<space>
nnoremap <silent> <leader>mn  :<C-u>CocList snippets<cr>
" buffers
nnoremap <silent> <leader><space>  :<C-u>CocList -N --normal buffers<cr>
" Show all diagnostics
nnoremap <silent> <leader>md  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <leader>me  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <leader>mc  :<C-u>CocList -N commands<cr>
" Find symbol of current document
nnoremap <silent> <leader>mo  :<C-u>CocList outline<cr>
" mru
nnoremap <silent> <leader>, :<C-u>CocList -N mru<cr>
" files
nnoremap <silent> <leader>mf :<C-u>CocList files<cr>
nnoremap <silent> <leader>mv :<C-u>cd ~/.dotfiles/dotconfig/nvim <bar> CocList files<cr>
" help
nnoremap <silent> <leader>mh :<C-u>CocList helptags<cr>
" filetypes
nnoremap <silent> <leader>mt :<C-u>CocList filetypes<cr>
" words
nnoremap <silent> <leader>mw :<C-u>CocList words<cr>
" Search workspace symbols
" nnoremap <silent> <leader>ms  :<C-u>CocList -I symbols<cr>
" Sessions
nnoremap <silent> <leader>ms  :<C-u>CocList -N sessions<cr>
" Resume latest coc list
nnoremap <silent> <leader>mr  :<C-u>CocListResume<cr>
" yank
nnoremap <silent> <leader>my  :<C-u>CocList -A --normal yank<cr>
" grep with selected content
vnoremap <silent> <leader>mg :<C-u>call <SID>GrepFromSelected(visualmode())<CR>

" nnoremap <silent> <leader>mg :<C-u>set operatorfunc=<SID>GrepFromSelected<CR>g@
" coc-git
nnoremap <silent> <leader>mb  :<C-u>CocList -A --normal bcommits<cr>
" nnoremap <silent> <leader>ms  :<C-u>CocList -A --normal gstatus<cr>

" Keymapping for grep word under cursor with interactive mode
nnoremap <silent> <leader>mg :exe 'CocList -I --input='.expand('<cword>').' grep'<CR>

nnoremap <silent> <leader>j :<C-u>CocList grep<CR>

" grep word under cursor.
" nnoremap <silent> <leader>j  :exe 'CocList -I --normal --input='.expand('<cword>').' words'<CR>


nnoremap <silent><expr> / line('$') > 10000 ? '/' :
  \ ":\<C-u>CocList words<CR>"
nnoremap <silent><expr> n line('$') > 10000 ? 'n' :
  \ ":\<C-u>CocListResume<CR>"
nnoremap <silent><expr> * line('$') > 10000 ? '*' :
        \ ":exe 'CocList -I --normal --input='.expand('<cword>').' words'<CR>"

" navigate chunks of current buffer
nmap [g <Plug>(coc-git-prevchunk)
nmap ]g <Plug>(coc-git-nextchunk)
" show chunk diff at current position
nmap gs <Plug>(coc-git-chunkinfo)
" show commit contains current position
nmap gc <Plug>(coc-git-commit)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K for show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)
nmap <leader>rf <Plug>(coc-refactor)
nmap <leader>rl <Plug>(coc-codelens-action)

" Remap for format selected region
vmap \f  <Plug>(coc-format-selected)
nmap \f  <Plug>(coc-format-selected)

nmap <silent> \t <Plug>(coc-translator-p)

" Remap for do codeAction of selected region, ex: `,aap` for current paragraph
xmap <leader>ac  <Plug>(coc-codeaction-selected)
nmap <leader>ac  <Plug>(coc-codeaction)

" Fix autofix problem of current line
nmap \q  <Plug>(coc-fix-current)

" Multiple cursors support
" nmap <silent> <C-c> <Plug>(coc-cursors-position)
" nmap <silent> <C-d> <Plug>(coc-cursors-word)
" xmap <silent> <C-d> <Plug>(coc-cursors-range)
" use normal command like `<leader>ii(`
" nmap <leader>i  <Plug>(coc-cursors-operator)

nmap <silent> <C-d> <Plug>(coc-cursors-word)*
xmap <silent> <C-d> y/\V<C-r>=escape(@",'/\')<CR><CR>gN<Plug>(coc-cursors-range)gn

nnoremap <silent> ;f :<C-u>CocCommand eslint.executeAutofix<CR>
nnoremap <silent> <C-f> :<C-u>CocCommand prettier.formatFile<CR>
"}}}

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

" grep word under cursor
command! -nargs=+ -complete=custom,s:GrepArgs Rg exe 'CocList grep '.<q-args>

function! s:GrepArgs(...)
  let list = ['-S', '-smartcase', '-i', '-ignorecase', '-w', '-word',
        \ '-e', '-regex', '-u', '-skip-vcs-ignores', '-t', '-extension']
  return join(list, "\n")
endfunction

" vim: set ts=2 sw=2 tw=80 fdl=0 et :
