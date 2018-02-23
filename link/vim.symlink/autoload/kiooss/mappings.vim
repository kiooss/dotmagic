" denite key mappings
function! kiooss#mappings#denite() abort
  nnoremap <silent> <leader>f  :<C-u>Denite file_rec/git -highlight-mode-insert=Search<CR>
  nnoremap <silent> <leader>ol :<C-u>Denite outline -highlight-mode-insert=Search<CR>
  nnoremap <silent> <leader>ls :<C-u>Denite buffer -mode=normal<CR>
  nnoremap <silent> <leader>m :<C-u>Denite file_mru -highlight-mode-insert=Search<CR>
  nnoremap <silent> <Leader>r
        \ :<C-u>Denite -mode=normal -buffer-name=register
        \ -highlight-mode-insert=Search register<CR>
  xnoremap <silent> <Leader>r
        \ :<C-u>Denite -mode=normal -default-action=replace -buffer-name=register
        \ -highlight-mode-insert=Search register<CR>
  nnoremap <silent> / :<C-u>Denite -buffer-name=search
        \ -highlight-mode-insert=Search line<CR>
  nnoremap <silent> * :<C-u>DeniteCursorWord -buffer-name=search
        \ -mode=normal line<CR>
  nnoremap <silent> # :<C-u>DeniteCursorWord -buffer-name=search
        \ -no-empty -mode=normal grep/git<CR>
  nnoremap <silent> <leader>s :<C-u>Denite file_point file_old
        \ `finddir('.git', ';') != '' ? 'file_rec/git' : 'file_rec'`<CR>
  " nnoremap <silent><expr> tt  &filetype == 'help' ?  "g\<C-]>" :
  "       \ ":\<C-u>DeniteCursorWord -buffer-name=tag -immediately
  "       \  tag:include\<CR>"
  " nnoremap <silent><expr> ;t :<C-u>DeniteCursorWord --buffer-name=tag
  "       \ tag:include<CR>
  nnoremap <silent><expr> tp  &filetype == 'help' ?
        \ ":\<C-u>pop\<CR>" : ":\<C-u>Denite -mode=normal jump\<CR>"

  nnoremap <silent> <LocalLeader>v
        \ :<C-u>Denite file_rec:~/.vim -highlight-mode-insert=Search<CR>
  nnoremap <silent> <LocalLeader>d
        \ :<C-u>Denite file_rec:~/.dotfiles -highlight-mode-insert=Search<CR>
  nnoremap <silent> <LocalLeader>n :<C-u>Denite dein -default-action=open<CR>
  nnoremap <silent> <LocalLeader>c :<C-u>Denite colorscheme -auto-preview<CR>
  nnoremap <silent> <LocalLeader>ft :<C-u>Denite filetype -highlight-mode-insert=Search<CR>
  nnoremap <silent> <LocalLeader>h :<C-u>Denite help<CR>

  nnoremap <silent> <Leader>ag :<C-u>Denite -buffer-name=search
        \ -no-empty -mode=normal grep<CR>
  nnoremap <silent> <Leader>gg :<C-u>Denite -buffer-name=search
        \ -no-empty -mode=normal grep/git<CR>
  nnoremap <silent> <Leader>st :<C-u>Denite -buffer-name=search
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

  " denite-rails
  nnoremap [rails] <Nop>
  nmap     [Window]r [rails]
  nnoremap <silent> [rails]r :<C-u>Denite<Space>rails:dwim<Return>
  nnoremap <silent> [rails]m :<C-u>Denite<Space>rails:model<Return>
  nnoremap <silent> [rails]c :<C-u>Denite<Space>rails:controller<Return>
  nnoremap <silent> [rails]v :<C-u>Denite<Space>rails:view<Return>
  nnoremap <silent> [rails]h :<C-u>Denite<Space>rails:helper<Return>
  nnoremap <silent> [rails]t :<C-u>Denite<Space>rails:test<Return>
  nnoremap <silent> [rails]s :<C-u>Denite<Space>rails:spec<Return>
endfunction
