" denite key mappings
function! kiooss#mappings#denite#init() abort
  nnoremap <silent><LocalLeader>b :<C-u>Denite buffer file/old -default-action=switch<CR>
  nnoremap <silent><LocalLeader>o :<C-u>Denite outline<CR>
  nnoremap <silent><LocalLeader>v :<C-u>Denite file_rec/git:~/.dotfiles/link/vim.symlink/<CR>
  nnoremap <silent><LocalLeader>; :<C-u>Denite command command_history<CR>
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
  " nnoremap <silent><expr> tt  &filetype == 'help' ?  "g\<C-]>" :
  "       \ ":\<C-u>DeniteCursorWord -buffer-name=tag -immediately
  "       \  tag:include\<CR>"
  " nnoremap <silent><expr> ;t :<C-u>DeniteCursorWord --buffer-name=tag
  "       \ tag:include<CR>
  nnoremap <silent><expr> tp  &filetype == 'help' ?
        \ ":\<C-u>pop\<CR>" : ":\<C-u>Denite -mode=normal jump\<CR>"

  nnoremap <silent> <Leader>vn :<C-u>Denite dein -default-action=open<CR>
  nnoremap <silent> <Leader>vc :<C-u>Denite colorscheme -auto-preview<CR>
  nnoremap <silent> <Leader>ft :<C-u>Denite filetype -highlight-mode-insert=Search<CR>
  nnoremap <silent> <Leader>vh :<C-u>Denite -buffer-name=search help<CR>

  nnoremap <silent> <Leader>ga :<C-u>Denite -buffer-name=search
        \ -no-empty -mode=normal grep<CR>
  nnoremap <silent> <Leader>gg :<C-u>Denite -buffer-name=search
        \ -no-empty -mode=normal grep/git<CR>
  nnoremap <silent> <Leader>st :<C-u>Denite -buffer-name=search
        \ -no-empty -mode=normal gitstatus<CR>
  nnoremap <silent> n :<C-u>Denite -buffer-name=search
        \ -resume -mode=normal -refresh<CR>
  " nnoremap <silent> <C-t> :<C-u>Denite
  "       \ -select=`tabpagenr()-1` -mode=normal deol<CR>
  " nnoremap <silent> <Leader>j :<C-u>Denite -mode=normal change jump<CR>
  nnoremap <silent> <Leader>gl :<C-u>Denite -buffer-name=search
        \ -no-empty -mode=normal gitlog<CR>
  nnoremap <silent> <Leader>gs :<C-u>Denite -mode=normal gitstatus<CR>

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
