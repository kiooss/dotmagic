slash-backward-kill-word() {
  local WORDCHARS="${WORDCHARS:s@/@}"
  zle backward-kill-word
}
zle -N slash-backward-kill-word
# <alt+backspace>
bindkey '\e^?' slash-backward-kill-word

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


if (( $+commands[ranger] )); then
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
fi

bindkey -s '\em' '^Umycli -u root^M'
if (( $+commands[mycli] )); then
  bindkey -s '\em' '^Umycli -u root^M'
fi

goto-gitroot() {
  cd $(git rev-parse --show-toplevel 2> /dev/null || echo -n ".")
  VISUAL=true zle edit-command-line
}
zle -N goto-gitroot
bindkey '^g' goto-gitroot

autosuggest-accept-line() {
  zle autosuggest-accept
  zle accept-line
}
zle -N autosuggest-accept-line
bindkey '^j' autosuggest-accept-line

git-publish() {
  local message="$BUFFER"
  cd $(git rev-parse --show-toplevel 2> /dev/null || echo -n ".")
  BUFFER="git add -A && git commit -m '${message}' && git push"
  zle end-of-line
}
zle -N git-publish
bindkey '^x^g' git-publish
