"---------------------------------------------------------------------------
" vimrc functions:
"

function! vimrc#sticky_func() abort
  let sticky_table = {
        \',' : '<', '.' : '>', '/' : '?',
        \'1' : '!', '2' : '@', '3' : '#', '4' : '$', '5' : '%',
        \'6' : '^', '7' : '&', '8' : '*', '9' : '(', '0' : ')',
        \ '-' : '_', '=' : '+',
        \';' : ':', '[' : '{', ']' : '}', '`' : '~', "'" : "\"", '\' : '|',
        \}
  let special_table = {
        \"\<ESC>" : "\<ESC>", "\<Space>" : ';', "\<CR>" : ";\<CR>"
        \}

  if mode() !~# '^c'
    echo 'Input sticky key: '
  endif
  let char = ''

  while 1
    let char = nr2char(getchar())

    if char =~ '\l'
      let char = toupper(char)
      break
    elseif has_key(sticky_table, char)
      let char = sticky_table[char]
      break
    elseif has_key(special_table, char)
      let char = special_table[char]
      break
    endif
  endwhile

  redraw | echo
  return char
endfunction

function! vimrc#add_numbers(num) abort
  let prev_line = getline('.')[: col('.')-1]
  let next_line = getline('.')[col('.') :]
  let prev_num = matchstr(prev_line, '\d\+$')
  if prev_num != ''
    let next_num = matchstr(next_line, '^\d\+')
    let new_line = prev_line[: -len(prev_num)-1] .
          \ printf('%0'.len(prev_num . next_num).'d',
          \    max([0, substitute(prev_num . next_num, '^0\+', '', '')
          \         + a:num])) . next_line[len(next_num):]
  else
    let new_line = prev_line . substitute(next_line, '\d\+',
          \ "\\=printf('%0'.len(submatch(0)).'d',
          \         max([0, substitute(submatch(0), '^0\+', '', '')
          \              + a:num]))", '')
  endif

  if getline('.') !=# new_line
    call setline('.', new_line)
  endif
endfunction

function! vimrc#toggle_option(option_name) abort
  execute 'setlocal' a:option_name.'!'
  execute 'setlocal' a:option_name.'?'
endfunction

function! vimrc#on_filetype() abort "{{{
  if execute('filetype') =~# 'OFF'
    " Lazy loading
    silent! filetype plugin indent on
    syntax enable
    filetype detect
  endif
endfunction "}}}


" let s:middot='·'
let s:middot="\ue77f"
" let s:raquo='»'
let s:raquo="\uf115+"
let s:small_l='ℓ'

" Override default `foldtext()`, which produces something like:
"
"   +---  2 lines: source $HOME/.vim/pack/bundle/opt/vim-pathogen/autoload/pathogen.vim--------------------------------
"
" Instead returning:
"
"   »··[2ℓ]··: source $HOME/.vim/pack/bundle/opt/vim-pathogen/autoload/pathogen.vim···································
"
function! vimrc#foldtext() abort
  let l:lines='[' . (v:foldend - v:foldstart + 1) . s:small_l . ']'
  let l:first=substitute(getline(v:foldstart), '\v *', '', '')
  let l:dashes=substitute(v:folddashes, '-', s:middot, 'g')
  return s:raquo . s:middot . s:middot . l:lines . l:dashes . ': ' . l:first
endfunction

" Improved Vim fold-text
" See: http://www.gregsexton.org/2011/03/improving-the-text-displayed-in-a-fold/
function! vimrc#MyFoldText()
  " Get first non-blank line
  let fs = v:foldstart
  while getline(fs) =~? '^\s*$' | let fs = nextnonblank(fs + 1)
  endwhile
  if fs > v:foldend
    let line = getline(v:foldstart)
  else
    let line = substitute(getline(fs), '\t', repeat(' ', &tabstop), 'g')
  endif

  let w = winwidth(0) - &foldcolumn - (&number ? 8 : 0)
  let foldSize = 1 + v:foldend - v:foldstart
  let foldSizeStr = ' ' . foldSize . ' lines '
  let foldLevelStr = repeat('+--', v:foldlevel)
  let lineCount = line('$')
  let foldPercentage = printf('[%.1f', (foldSize*1.0)/lineCount*100) . '%] '
  let expansionString = repeat('.', w - strwidth(foldSizeStr.line.foldLevelStr.foldPercentage))
  return s:raquo . line . expansionString . foldSizeStr . foldPercentage . foldLevelStr
endfunction
