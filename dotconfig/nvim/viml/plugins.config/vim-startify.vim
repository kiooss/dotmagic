" autocmd User Startified doautocmd ColorScheme
autocmd User Startified for key in ['b','s','t','v'] | exe 'nunmap <buffer>' key | endfor
" let g:startify_change_to_dir       = 1
let g:startify_change_to_vcs_root  = 1
let g:startify_update_oldfiles     = 1
let g:startify_fortune_use_unicode = 1
let g:startify_session_dir = '~/.cache/vim/sessions'
" let g:startify_custom_header =
"       \ map(split(system('fortune | cowsay -f dragon-and-cow'), '\n'), '"   ". v:val')
let g:startify_lists = [
      \ { 'type': 'sessions',  'header': ['   ❐ SESSIONS']       },
      \ { 'type': 'dir',       'header': ['    MRU '. getcwd()] },
      \ { 'type': 'files',     'header': ['    MRU']            },
      \ { 'type': 'bookmarks', 'header': ['    BOOKMARKS']      },
      \ { 'type': 'commands',  'header': ['   גּ COMMANDS']       },
      \ ]
let g:startify_bookmarks = [
        \ { 'tc': '~/.tmux.conf' },
        \ ]
let g:startify_commands = [
    \ { 'c1': ['Vim Reference', 'h ref'] },
    \ { 'c2': ['Vim CheckHealth', 'CheckHealth'] },
    \ ]
let g:startify_skiplist = [
    \ 'COMMIT_EDITMSG',
    \ '.git/*',
    \ 'runtime/doc/.*\.txt',
    \ 'bundle/.*/doc/.*\.txt',
    \ 'plugged/.*/doc/.*\.txt',
    \ escape(fnamemodify(resolve($VIMRUNTIME), ':p'), '\') .'doc/.*\.txt',
    \ ]

function! StartifyEntryFormat()
  " return 'WebDevIconsGetFileTypeSymbol(absolute_path) ." ". entry_path'
  return 'v:lua.require("utils").webDevIcons(absolute_path) . " " . entry_path'
endfunction
