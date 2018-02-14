" denite key mappings
function! kiooss#mappings#denite() abort
  nnoremap <silent> <leader>f  :<C-u>Denite file_rec/git -highlight-mode-insert=Search<CR>
  " nnoremap <silent> <leader>r  :<C-u>Denite register -mode=normal -highlight-mode-insert=Search<CR>
  nnoremap <silent> <leader>ol :<C-u>Denite outline -highlight-mode-insert=Search<CR>
  nnoremap <silent> <leader>ls :<C-u>Denite buffer<CR>
  nnoremap <silent> <leader>m :<C-u>Denite file_mru -highlight-mode-insert=Search<CR>
  nnoremap <silent> <Leader>r
        \ :<C-u>Denite -mode=normal -buffer-name=register
        \ -highlight-mode-insert=Search register<CR>
  xnoremap <silent> <Leader>r
        \ :<C-u>Denite -mode=normal -default-action=replace -buffer-name=register
        \ -highlight-mode-insert=Search register<CR>
  nnoremap <silent> <LocalLeader>v
        \ :<C-u>Denite file_rec:~/.vim -highlight-mode-insert=Search<CR>
  nnoremap <silent> <LocalLeader>d
        \ :<C-u>Denite file_rec:~/.dotfiles -highlight-mode-insert=Search<CR>
  nnoremap <silent> / :<C-u>Denite -buffer-name=search
        \ -highlight-mode-insert=Search line<CR>
  nnoremap <silent> * :<C-u>DeniteCursorWord -buffer-name=search
        \ -mode=normal line<CR>
  nnoremap <silent> # :<C-u>DeniteCursorWord -buffer-name=search
        \ -no-empty -mode=normal grep/git<CR>
  nnoremap <silent> <leader>s :<C-u>Denite file_point file_old
        \ `finddir('.git', ';') != '' ? 'file_rec/git' : 'file_rec'`<CR>
  nnoremap <silent><expr> tt  &filetype == 'help' ?  "g\<C-]>" :
        \ ":\<C-u>DeniteCursorWord -buffer-name=tag -immediately
        \  tag:include\<CR>"
  " nnoremap <silent><expr> ;t :<C-u>DeniteCursorWord --buffer-name=tag
  "       \ tag:include<CR>
  nnoremap <silent><expr> tp  &filetype == 'help' ?
        \ ":\<C-u>pop\<CR>" : ":\<C-u>Denite -mode=normal jump\<CR>"

  nnoremap <silent> [Window]n :<C-u>Denite dein<CR>
  nnoremap <silent> [Window]c :<C-u>Denite colorscheme -auto-preview<CR>
  nnoremap <silent> [Window]ft :<C-u>Denite filetype -highlight-mode-insert=Search<CR>
  nnoremap <silent> [Window]h :<C-u>Denite help<CR>

  nnoremap <silent> <leader>ag :<C-u>Denite -buffer-name=search
        \ -no-empty -mode=normal grep<CR>
  nnoremap <silent> <leader>gg :<C-u>Denite -buffer-name=search
        \ -no-empty -mode=normal grep/git<CR>
  nnoremap <silent> <leader>st :<C-u>Denite -buffer-name=search
        \ -no-empty -mode=normal gitstatus<CR>
  nnoremap <silent> n :<C-u>Denite -buffer-name=search
        \ -resume -mode=normal -refresh<CR>
  " nnoremap <silent> <C-t> :<C-u>Denite
  "       \ -select=`tabpagenr()-1` -mode=normal deol<CR>
  nnoremap <silent> <Leader>j :<C-u>Denite -mode=normal change jump<CR>
  nnoremap <silent> <Leader>gl :<C-u>Denite -buffer-name=search
        \ -no-empty -mode=normal gitlog<CR>
  nnoremap <silent> <Leader>gs :<C-u>Denite -mode=normal gitstatus<CR>
  " nnoremap <silent> ;;
  "       \ :<C-u>Denite command command_history<CR>
endfunction
