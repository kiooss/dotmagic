" empty current buffer
function! kiooss#util#BufferEmpty() abort
  let l:current = bufnr('%')
  if ! getbufvar(l:current, '&modified')
    enew
    silent! execute 'bdelete '.l:current
  endif
endfunction

" delete buffer smartly
function! kiooss#util#BufferDelete() abort
  let l:current = bufnr('%')
  if getbufvar(l:current, '&modified')
    echohl ErrorMsg
    echomsg 'No write since last change. Not closing buffer.'
    echohl NONE
  else
    let s:total_nr_buffers = len(filter(range(1, bufnr('$')), 'buflisted(v:val)'))

    if s:total_nr_buffers == 0
      " there is no listed buffer, just quit
      quit
    elseif s:total_nr_buffers == 1
      " bdelete
      quit
    else
      bprevious
      silent! execute 'bdelete '.l:current
    endif
  endif
endfunction

" quit window or delete buffer smartly
function! kiooss#util#SmartQuit() abort
  let l:number_of_windows_to_this_buffer = len(filter(range(1, winnr('$')), "winbufnr(v:val) == bufnr('%')"))

  " never bdelete a nerd tree
  if matchstr(expand('%'), 'NERD') ==# 'NERD'
    wincmd c
    return
  endif

  if exists('#goyo')
    " if in goyo mode
    quit
    return
  endif

  if l:number_of_windows_to_this_buffer > 1
    wincmd c
  else
    " bdelete
    call kiooss#util#BufferDelete()
  endif
endfunction

" https://stackoverflow.com/questions/1533565/how-to-get-visually-selected-text-in-vimscript
function! s:get_visual_selection()
  let [line_start, column_start] = getpos("'<")[1:2]
  let [line_end, column_end] = getpos("'>")[1:2]
  let lines = getline(line_start, line_end)
  if len(lines) == 0
    return ''
  endif
  let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
  let lines[0] = lines[0][column_start - 1:]
  return join(lines, "\n")
endfunction

function! kiooss#util#GrepSource() abort range
  let l:str = s:get_visual_selection()
  let l:str = escape(l:str, '\\/.*$^''~[]')
  let l:str = substitute(l:str, "\n$", '', '')

  execute 'Denite grep/git -buffer-name=search -no-empty -mode=normal -input='.l:str
endfunction

function! kiooss#util#SetFtByContext() abort
  execute 'set ft='.context_filetype#get_filetype()
endfunction

function! kiooss#util#ReplaceDelimiter() abort
  let l:delimiter = input('Delimiter: ')
  silent! execute 's/'.l:delimiter.'/\r/g'
  redraw!
endfunction
