slash-backward-kill-word() {
    local WORDCHARS="${WORDCHARS:s@/@}"
    zle backward-kill-word
}
zle -N slash-backward-kill-word
# <alt+backspace>
bindkey '\e^?' slash-backward-kill-word
