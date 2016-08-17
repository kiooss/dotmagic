# example
# Bind \eg to `git status`
# function _git-status {
#     zle kill-whole-line
#     zle -U "git status"
#     zle accept-line
# }
# zle -N _git-status
# bindkey '\eg' _git-status


bindkey -s '\eg' '^Ugit status^M'
bindkey -s '\ec' '^Ugit add -A && git commit^M'

bindkey -s '\el' '^Ull^M'
bindkey -s '\em' '^Umysql -u root^M'
