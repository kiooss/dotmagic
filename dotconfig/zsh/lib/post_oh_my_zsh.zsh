# zsh-autosuggestions {{{
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
bindkey '^j' autosuggest-accept

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#00fa9a,bold,underline"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
# }}}

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)
ZSH_HIGHLIGHT_STYLES[cursor]='bold'

ZSH_HIGHLIGHT_STYLES[alias]='fg=green,bold'
ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=magenta,bold'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=blue,bold'
ZSH_HIGHLIGHT_STYLES[function]='fg=cyan,bold'
ZSH_HIGHLIGHT_STYLES[command]='fg=yellow,bold'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=lightgreen,bold'
ZSH_HIGHLIGHT_STYLES[hashed-command]='fg=lightblue,bold'

# the composer plugin create the c alias but I do not need it.
unalias c 2>/dev/null
unalias g 2>/dev/null

unalias rg 2>/dev/null

# filename completion as a default when other completions fail
# zstyle ':completion:*' completer _complete _ignored _files

# zle -C complete-file complete-word _generic
# zstyle ':completion:complete-file::::' completer _files
# bindkey '^xF' complete-file

# fix paste slow issue
zstyle ':bracketed-paste-magic' active-widgets '.self-*'

zstyle ':completion:*' verbose yes

# zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:descriptions' format '%F{yellow}留%f%F{green}%d%f'
zstyle ':completion:*:messages' format '%F{yellow}留%f%F{green}%d%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'

# Grouping Results
zstyle ':completion:*' group-name ''

zstyle ':completion:*' menu select
zstyle ':completion:*:*:default' force-list always
zstyle ':completion:*' select-prompt '%SSelect:  lines: %L  matches: %M  [%p]'

# zstyle ':completion:*:match:*' original only
# zstyle ':completion::prefix-1:*' completer _complete
# zstyle ':completion:predict:*' completer _complete
# zstyle ':completion:incremental:*' completer _complete _correct
# zstyle ':completion:*' completer _complete _prefix _correct _match _approximate

#路径补全
zstyle ':completion:*' expand 'yes'
zstyle ':completion:*' squeeze-shlashes 'yes'
zstyle ':completion::complete:*' '\\'

zstyle ':completion:*:options' list-colors '=^(-- *)=34'
