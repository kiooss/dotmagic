ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
ZSH_HIGHLIGHT_STYLES[cursor]='bold'

ZSH_HIGHLIGHT_STYLES[alias]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[function]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[command]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[hashed-command]='fg=green,bold'


rule () {
  print -Pn '%F{blue}'
  local columns=$(tput cols)
  for ((i=1; i<=columns; i++)); do
    printf "\u2588"
  done
  print -P '%f'
}

function _my_clear() {
  echo
  rule
  zle clear-screen
}
zle -N _my_clear
bindkey '^l' _my_clear


# Ctrl-O opens zsh at the current location, and on exit, cd into ranger's last location.
ranger-cd() {
tempfile=$(mktemp)
ranger --choosedir="$tempfile" "${@:-$(pwd)}" < $TTY
test -f "$tempfile" &&
  if [ "$(cat -- "$tempfile")" != "$(echo -n `pwd`)" ]; then
    cd -- "$(cat "$tempfile")"
  fi
  rm -f -- "$tempfile"
  # hacky way of transferring over previous command and updating the screen
  VISUAL=true zle edit-command-line
}
zle -N ranger-cd
bindkey '^o' ranger-cd
