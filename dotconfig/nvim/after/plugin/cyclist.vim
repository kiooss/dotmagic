set list

if !get(g:, 'loaded_cyclist', v:false)
  finish
endif

" 普段使い: 改行・タブ・行末空白・nbsp
call cyclist#add_listchar_option_set('default', {
        \ 'eol': '¬',
        \ 'tab': '→ ',
        \ 'trail': '·',
        \ 'nbsp': '␣',
        \ 'extends': '›',
        \ 'precedes': '‹',
        \ })

" 確認用: 全スペースと改行も表示
call cyclist#add_listchar_option_set('busy', {
        \ 'eol': '¬',
        \ 'tab': '→ ',
        \ 'space': '·',
        \ 'trail': '•',
        \ 'nbsp': '␣',
        \ 'extends': '›',
        \ 'precedes': '‹',
        \ })

silent! call cyclist#activate_listchars('default')

nmap <leader>tl <Plug>CyclistNext
