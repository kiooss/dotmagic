# zsh-autosuggestions {{{
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
bindkey '^ ' autosuggest-accept
# ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=cyan'
# }}}

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
ZSH_HIGHLIGHT_STYLES[cursor]='bold'

ZSH_HIGHLIGHT_STYLES[alias]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[function]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[command]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[hashed-command]='fg=green,bold'

# the composer plugin create the c alias but I do not need it.
unalias c 2>/dev/null
unalias g 2>/dev/null

# filename completion as a default when other completions fail
# zstyle ':completion:*' completer _complete _ignored _files

zle -C complete-file complete-word _generic
zstyle ':completion:complete-file::::' completer _files
bindkey '^xF' complete-file

