###############################################################################
# Yang Yang's zsh config.
# kiooss@gmail.com
# vim: set ts=2 sw=2 tw=80 et fdm=marker fdl=0:
###############################################################################

# Enable Powerlevel10k instant prompt. {{{
# Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
# }}}

# PROFILE_STARTUP {{{
PROFILE_STARTUP=false
if [[ "$PROFILE_STARTUP" == true ]]; then
  zmodload zsh/zprof # Output load-time statistics
  # http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html
  PS4=$'%D{%M%S%.} %N:%i> '
  # exec 3>&2 2>"${XDG_CACHE_HOME:-$HOME/tmp}/zsh_statup.$$"
  exec 3>&2 2>"/tmp/zsh_statup.$$"
  setopt xtrace prompt_subst
fi
# }}}

# Base config {{{
# Path to your oh-my-zsh configuration.
export ZSH="$HOME/.oh-my-zsh"
# export is important if you want to use DOTFILES env in sub shell.
export DOTFILES="$HOME/.dotfiles"
# whether use patched font (for shell, tmux, and vim)
export ENABLE_PATCHED_FONT=true

MYZSH="$DOTFILES/zsh"
ZSH_CUSTOM="$MYZSH/omz_custom"
# ZSH_THEME=""
# ZSH_THEME="powerlevel9k/powerlevel9k"
ZSH_THEME="powerlevel10k/powerlevel10k"

# Remove duplicates in the following arrays.
typeset -U path cdpath fpath manpath

[[ -e ~/.terminfo ]] && export TERMINFO_DIRS=~/.terminfo:/usr/share/terminfo
# [[ -z "$TMUX" ]] && export TERM=xterm-256color

# define the code directory
# This is where my code exists and where I want the `c` autocomplete to work from exclusively
[[ -d ~/workspace ]] && export CODE_DIR=~/workspace
[[ -d ~/.cache ]] && export CACHE_DIR=~/.cache

[[ -f "$HOME/.env.local" ]] && source "$HOME/.env.local"

[[ "$OSTYPE" = darwin* ]] && export SUDO_ASKPASS="$DOTFILES/bin/macos_sudo_askpass.sh"
# }}}

# PATH config {{{
# export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$PATH
# adding path directory for custom scripts
export PATH="$DOTFILES/bin:$PATH"
# check for custom bin directory and add to path
[[ -d "$HOME/bin" ]] && export PATH="$HOME/bin:$PATH"
[[ -d "$HOME/.local/bin" ]] && export PATH="$HOME/.local/bin:$PATH"
[[ -d "$HOME/.cargo/bin" ]] && export PATH="$HOME/.cargo/bin:$PATH"
[[ -d "$HOME/dev/flutter/bin" ]] && export PATH="$HOME/dev/flutter/bin:$PATH"
# [[ -d "$HOME/venv/py3/bin/" ]] && export PATH="$HOME/venv/py3/bin/:$PATH"
# rbenv
# export PATH="$DOTFILES/vendor/rbenv/bin:$PATH"
export PATH="$HOME/.rbenv/bin:$PATH"
# pyenv
# export PATH="$HOME/.pyenv/bin:$PATH"

export N_PREFIX=$HOME/.n
export PATH=$N_PREFIX/bin:$PATH

# Add android tools
if [[ -d /Applications/adt-bundle-mac-x86_64 ]]; then
  export ANDROID_HOME="/Applications/adt-bundle-mac-x86_64/sdk"
  export PATH=${PATH}:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$ANDROID_HOME/cmdline-tools/latest/bin
fi

export PATH=$PATH:$HOME/.dasht/bin
export MANPATH=$HOME/.dasht/man:$MANPATH

export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

if [[ -d $HOME/.symfony/bin ]]; then
  export PATH=$HOME/.symfony/bin:$PATH
fi
# }}}

# EDITOR ENV {{{
if (( $+commands[nvim] )); then
  export EDITOR=nvim
  export MANPAGER='nvim +Man!'
elif (( $+commands[vim] )); then
  export EDITOR=vim
else
  export EDITOR=vi
fi
export BUNDLER_EDITOR="$EDITOR"
export SVN_EDITOR="$EDITOR"
export GIT_EDITOR="$EDITOR"
# }}}

# oh-my-zsh config {{{
# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Comment this out to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how often before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment following line if you want to disable command autocorrection
# DISABLE_CORRECTION="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to disable marking untracked files under
# VCS as dirty. This makes repository status check for large repositories much,
# much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

if [[ -n $SSHIDFILE ]]; then
  # zstyle :omz:plugins:ssh-agent agent-forwarding on
  zstyle :omz:plugins:ssh-agent identities $SSHIDFILE
  # zstyle :omz:plugins:ssh-agent lifetime 4h
fi

# }}}

# plugins config {{{
# oh-my-zsh plugins
plugins=(
  aliases
  cp
  capistrano
  colored-man-pages
  # emoji
  encode64
  fancy-ctrl-z
  # git
  gem
  history-substring-search
  nmap
  npm
  systemadmin
  # ssh-agent
  tmuxinator
  # themes
  # z
  zsh-autosuggestions
  zsh-navigation-tools
  zsh-syntax-highlighting
  zsh-completions
)

plugins_on_need=(
  composer
  react-native
  yarn
  docker
  vagrant
)

for plugin ($plugins_on_need); do
  if (( $+commands[$plugin] )); then
    plugins=($plugins $plugin)
  fi
done

# my own zsh plugins
my_plugins=(
  abbreviations
  add-http-proxy
  aliases
  auto-ls-after-cd
  # fix-ssh-agent
  insert-datestamp
  mysql
  # thirsty
  # todotxt
  util-functions
)

if [[ "$OSTYPE" = darwin* ]]; then
  # plugin used in my mac.
  plugins=(
    $plugins
    # adb
    # gradle
    pass
    # vagrant-prompt
  )

  my_plugins=(
    $my_plugins
    aliases-osx
    util-functions-osx
  )
else
  # plugin used in my dev machine.
  plugins=(
    $plugins
    ssh-agent
    command-not-found
    symfony
    symfony2
  )

  # don't use some plugin when run as root
  [[ $(print -P "%#") == '#' ]] || plugins=($plugins rails rake-fast)

  my_plugins=(
    $my_plugins
    tmux-pane-words
  )
fi
# }}}

# fpath {{{
# add all my own plugin dir to fpath.
for plugin ($my_plugins); do
  fpath=($MYZSH/plugins/$plugin $fpath)
done

fpath+=$HOME/.dasht/etc/zsh/completions/

# autoload function in functions dir
fpath=($MYZSH/functions $fpath)
autoload -U $MYZSH/functions/*(:t)
# }}}

# MY CUSTOM CONFIG {{{
# Load oh-my-zsh
source $ZSH/oh-my-zsh.sh

for config_file ($MYZSH/lib/*.zsh); do
  source $config_file
done
unset config_file

for plugin ($my_plugins); do
  source $MYZSH/plugins/$plugin/$plugin.plugin.zsh
done
unset plugin

if hash rbenv 2>/dev/null; then
  eval "$(rbenv init -)"
fi

# aws command completion
# source $HOME/.local/bin/aws_zsh_completer.sh

# base16-shell
# source $MYZSH/base16-shell/base16-shell.plugin.zsh

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"

if [[ -d "$HOME/.nix-profile/" ]]; then
  source $HOME/.nix-profile/etc/profile.d/nix.sh
fi

# Set up hub wrapper for git, if it is available; https://github.com/github/hub
if (( $+commands[hub] )); then
  alias git=hub
fi
# }}}

# FZF {{{
export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_DEFAULT_OPTS="--height 100% --reverse --border --history=$HOME/.fzf_history"
export FZF_CTRL_R_OPTS="--preview-window up:3 --preview 'echo {}'"
export FZF_CTRL_T_OPTS="--preview '[[ \$(file --mime {}) =~ binary ]] && echo {} is a binary file || (highlight -O ansi -l {} || coderay {} || rougify {} || cat {}) 2> /dev/null | head -500'"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# }}}

# phpbrew {{{
if [[ -e ~/.phpbrew/bashrc ]]; then
  export PHPBREW_RC_ENABLE=1
  source ~/.phpbrew/bashrc
  # export PATH="$HOME/.phpbrew/bin:$PATH"
  # generation by `phpbrew zsh`
  # phpbrew zsh --bind phpbrew --program phpbrew > ~/.phpbrew_completion.sh
  source ~/.phpbrew_completion.sh
fi
# }}}

# proxy {{{
function proxy-on() {
  local HOST=${MY_PROXY_HOST:-localhost}
  export https_proxy=http://$HOST:7890 http_proxy=http://$HOST:7890 all_proxy=socks5://$HOST:7891
  echo "on" > ~/.cache/proxy_state
}

function proxy-off() {
  unset all_proxy https_proxy http_proxy
  echo "off" > ~/.cache/proxy_state
}

function proxy-state() {
  if [[ -z "$all_proxy" ]]; then
    echo -n ""
  else
    echo -n "🚀"
  fi
}

if [[ -f ~/.cache/proxy_state && `cat ~/.cache/proxy_state` == 'on' ]]; then
  proxy-on
fi
# }}}

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

# Created by `userpath` on 2020-12-07 03:12:21
export PATH="$PATH:/Users/yang/Library/Python/3.9/bin"

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
fi

## https://wiki.archlinux.org/title/zsh#Persistent_rehash {{{
if type pacman &>/dev/null; then
  zshcache_time="$(date +%s%N)"

  autoload -Uz add-zsh-hook

  rehash_precmd() {
    if [[ -a /var/cache/zsh/pacman ]]; then
      local paccache_time="$(date -r /var/cache/zsh/pacman +%s%N)"
      if (( zshcache_time < paccache_time )); then
        rehash
        zshcache_time="$paccache_time"
      fi
    fi
  }

  add-zsh-hook -Uz precmd rehash_precmd
fi
#}}}

###-begin-pm2-completion-### {{{
### credits to npm for the completion file model
#
# Installation: pm2 completion >> ~/.bashrc  (or ~/.zshrc)
#

COMP_WORDBREAKS=${COMP_WORDBREAKS/=/}
COMP_WORDBREAKS=${COMP_WORDBREAKS/@/}
export COMP_WORDBREAKS

if type complete &>/dev/null; then
  _pm2_completion () {
    local si="$IFS"
    IFS=$'\n' COMPREPLY=($(COMP_CWORD="$COMP_CWORD" \
                           COMP_LINE="$COMP_LINE" \
                           COMP_POINT="$COMP_POINT" \
                           pm2 completion -- "${COMP_WORDS[@]}" \
                           2>/dev/null)) || return $?
    IFS="$si"
  }
  complete -o default -F _pm2_completion pm2
elif type compctl &>/dev/null; then
  _pm2_completion () {
    local cword line point words si
    read -Ac words
    read -cn cword
    let cword-=1
    read -l line
    read -ln point
    si="$IFS"
    IFS=$'\n' reply=($(COMP_CWORD="$cword" \
                       COMP_LINE="$line" \
                       COMP_POINT="$point" \
                       pm2 completion -- "${words[@]}" \
                       2>/dev/null)) || return $?
    IFS="$si"
  }
  compctl -K _pm2_completion + -f + pm2
fi
###-end-pm2-completion-###
#}}}

### fix cursor type after exit nvim {{{
_fix_cursor() {
   echo -ne '\e[5 q'
}

precmd_functions+=(_fix_cursor)
# }}}

# PROFILE_STARTUP_END {{{
if [[ "$PROFILE_STARTUP" == true ]]; then
  zprof
  unsetopt xtrace
  exec 2>&3 3>&-
fi
# }}}
