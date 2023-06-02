# use the vi navigation keys in menu completion
# bindkey -M menuselect 'h' vi-backward-char
# bindkey -M menuselect 'k' vi-up-line-or-history
# bindkey -M menuselect 'l' vi-forward-char
# bindkey -M menuselect 'j' vi-down-line-or-history

bindkey ^Y accept-search

# history-substring-search bind P and N for EMACS mode
bindkey -M emacs '^P' history-substring-search-up
bindkey -M emacs '^N' history-substring-search-down

# make terminal command navigation sane again
# bindkey '^[^[[D' backward-word
# bindkey '^[^[[C' forward-word
# bindkey '^[[D' backward-word
# bindkey '^[[C' forward-word
# bindkey '^[[5D' beginning-of-line
# bindkey '^[[5C' end-of-line


bindkey '^Q' push-line-or-edit

if (( $+commands[mycli] )); then
  bindkey -s '\em' '^Umycli -u root -proot --port=3307^M'
fi

if (( $+commands[tn] )); then
  bindkey -s '\ej' '^Utn^M'
fi
