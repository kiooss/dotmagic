# enable color support of ls and also add handy aliases
# if [ -x /usr/bin/dircolors ]; then
#     test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
# fi

# enable color support of ls and also add handy aliases (OSX)
# if [ -x /usr/local/bin/gdircolors ]; then
#     test -r ~/.dircolors && eval "$(gdircolors -b ~/.dircolors)" || eval "$(gdircolors -b)"
#     # alias ls='gls'
# fi

# Detect which `ls` flavor is in use
# if ls --color > /dev/null 2>&1; then # GNU `ls`
#     colorflag="--color"
# else # OS X `ls`
#     colorflag="-G"
# fi

(( $+commands[dircolors] )) && [[ -s "$HOME/.dircolors" ]] && eval "$(dircolors -b $HOME/.dircolors)"
