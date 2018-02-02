# use the vi navigation keys in menu completion
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

bindkey ^Y accept-search

# make terminal command navigation sane again
# bindkey '^[^[[D' backward-word
# bindkey '^[^[[C' forward-word
bindkey '^[[D' backward-word
bindkey '^[[C' forward-word
# bindkey '^[[5D' beginning-of-line
# bindkey '^[[5C' end-of-line
bindkey '^[[3~' delete-char
# bindkey '^?' backward-delete-char
