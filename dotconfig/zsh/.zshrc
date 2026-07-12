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
  exec 3>&2 2>"${XDG_CACHE_HOME:-$HOME/.cache}/zsh_startup.$$"
  setopt xtrace prompt_subst
fi
# }}}

# Base config {{{
# Path to your oh-my-zsh configuration.
export ZSH="$HOME/.oh-my-zsh"
# export is important if you want to use DOTFILES env in sub shell.
export DOTFILES="$HOME/.dotfiles"

ZSH_CUSTOM="$DOTFILES/zsh/omz_custom"
# ZSH_THEME=""
ZSH_THEME="powerlevel10k/powerlevel10k"

# Remove duplicates in the following arrays.
typeset -U path cdpath fpath manpath

[[ -e ~/.terminfo ]] && export TERMINFO_DIRS=~/.terminfo:/usr/share/terminfo

# define the code directory
# This is where my code exists and where I want the `c` autocomplete to work from exclusively
[[ -d ~/workspace ]] && export CODE_DIR=~/workspace
[[ -d ~/.cache ]] && export CACHE_DIR=~/.cache

[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"

[[ "$OSTYPE" = darwin* ]] && export SUDO_ASKPASS="$DOTFILES/bin/macos_sudo_askpass.sh"
# }}}

# PATH config {{{
export BUN_INSTALL="$HOME/.bun"

# single place for PATH; typeset -U path dedups, (N-/) drops missing dirs.
path=(
  $DOTFILES/bin
  $HOME/{bin,.local/bin}
  $HOME/.cargo/bin
  $BUN_INSTALL/bin
  $HOME/dev/flutter/bin
  $HOME/dev/flutter/.pub-cache/bin
  /opt/homebrew/opt/llvm/bin
  /usr/local/sbin
  $path
)
path=($^path(N-/))
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

# Auto-title disabled: each pane sets its own title via _geek_title (precmd)
# further down, and omz's command-name auto-title would fight it.
DISABLE_AUTO_TITLE="true"

# Command auto-correction is configured explicitly in lib/config.zsh
# (setopt CORRECT, unsetopt CORRECT_ALL) — omz's ENABLE_CORRECTION would turn
# CORRECT_ALL back on, so don't use it.

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
  # tmuxinator
  # themes
  # z
  zsh-autosuggestions
  zsh-navigation-tools
  zsh-syntax-highlighting
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
  # add-http-proxy
  aliases
  auto-ls-after-cd
  # fix-ssh-agent
  # insert-datestamp
  proxy
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
    brew
    pass
    # vagrant-prompt
  )

  my_plugins=(
    $my_plugins
    aliases-osx
    util-functions-osx
  )
  # .zprofile already ran brew shellenv — don't fork brew again here.
  fpath=(${HOMEBREW_PREFIX:-/opt/homebrew}/share/zsh/site-functions $fpath)
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
# autoload function in functions dir
fpath=($ZDOTDIR/functions $fpath)
# zsh-completions
fpath=($DOTFILES/vendor/zsh-completions/src $fpath)
autoload -U $ZDOTDIR/functions/*(:t)

autoload -Uz cdr
# }}}

# source $(brew --prefix)/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh
# bindkey '\t' menu-select "$terminfo[kcbt]" menu-select
# bindkey -M menuselect '\t' menu-complete "$terminfo[kcbt]" reverse-menu-complete

# Load oh-my-zsh
source $ZSH/oh-my-zsh.sh

# MY CUSTOM CONFIG {{{
for config_file ($ZDOTDIR/lib/*.zsh); do
  source $config_file
done
unset config_file

for plugin ($my_plugins); do
  source $ZDOTDIR/plugins/$plugin/$plugin.plugin.zsh
done
unset plugin

# rbenv: shims on PATH now, full init deferred to first `rbenv` call.
if [[ -d "$HOME/.rbenv/shims" ]]; then
  path=($HOME/.rbenv/shims $path)
  rbenv() {
    unfunction rbenv
    eval "$(command rbenv init -)"
    rbenv "$@"
  }
fi

# aws command completion
# source $HOME/.local/bin/aws_zsh_completer.sh
# }}}

# FZF {{{
export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_DEFAULT_OPTS="--height 100% --reverse --border --history=$HOME/.fzf_history"
export FZF_CTRL_R_OPTS="--preview-window up:3 --preview 'echo {}'"
export FZF_CTRL_T_OPTS="--preview '[[ \$(file --mime {}) =~ binary ]] && echo {} is a binary file || (highlight -O ansi -l {} || coderay {} || rougify {} || cat {}) 2> /dev/null | head -500'"
(( $+commands[fzf] )) && source <(fzf --zsh)

_fzf_complete_ssh() {
  _fzf_complete +m -- "$@" < <(
    setopt localoptions nonomatch
    # command cat <(command tail -n +1 ~/.ssh/config ~/.ssh/conf.d/* /etc/ssh/ssh_config 2> /dev/null | command grep -i '^\s*host\(name\)\? ' | awk '{for (i = 2; i <= NF; i++) print $1 " " $i}' | command grep -v '[*?]') \
    #     <(command grep -oE '^[[a-z0-9.,:-]+' ~/.ssh/known_hosts | tr ',' '\n' | tr -d '[' | awk '{ print $1 " " $1 }') \
    #     <(command grep -v '^\s*\(#\|$\)' /etc/hosts | command grep -Fv '0.0.0.0') |
    #     awk '{if (length($2) > 0) {print $2}}' | sort -u
    command cat <(command tail -n +1 ~/.ssh/config ~/.ssh/conf.d/* /etc/ssh/ssh_config 2> /dev/null | command grep -i '^\s*host\(name\)\? ' | awk '{for (i = 2; i <= NF; i++) print $1 " " $i}' | command grep -v '[*?]' ) |
        awk '{if (length($2) > 0) {print $2}}' | command grep -Ev "([0-9]{1,3}[\.]){3}[0-9]{1,3}" | sort -u
  )
}

_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf "$@" --preview 'tree -C {} | head -200' ;;
    *)            fzf "$@" ;;
  esac
}

# }}}

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f $ZDOTDIR/.p10k.zsh ]] || source $ZDOTDIR/.p10k.zsh

typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

# pyenv: shims on PATH now, full init (incl. virtualenv) deferred to first use.
# Deferring means virtualenv auto-activation starts after the first pyenv call.
export PYENV_ROOT="$HOME/.pyenv"
if [[ -d "$PYENV_ROOT" ]]; then
  path=($PYENV_ROOT/{bin,shims}(N-/) $path)
  pyenv() {
    unfunction pyenv
    eval "$(command pyenv init -)"
    eval "$(command pyenv virtualenv-init -)"
    pyenv "$@"
  }
fi

# NVM: lazy-loaded. The default version's bin dir goes straight on PATH (plain
# file read, no nvm.sh sourcing — that alone costs hundreds of ms); the real
# nvm loads on the first `nvm` call or the first .nvmrc encountered.
export NVM_DIR="$HOME/.config/nvm"

if [[ -s "$NVM_DIR/nvm.sh" ]]; then
  # resolve the default alias chain (e.g. default -> lts/* -> lts/jod -> vX.Y.Z)
  () {
    local ver
    local -i i
    [[ -f "$NVM_DIR/alias/default" ]] && ver="$(<$NVM_DIR/alias/default)"
    for i in {1..8}; do
      [[ -n "$ver" && -f "$NVM_DIR/alias/$ver" ]] || break
      ver="$(<$NVM_DIR/alias/$ver)"
    done
    [[ "$ver" == "system" ]] && return       # default=system: leave PATH alone
    [[ "$ver" == (node|stable) ]] && ver=""  # means "newest installed"
    local -a dirs
    if [[ -n "$ver" ]]; then
      # a concrete version: match it or add nothing (no silent wrong version)
      dirs=($NVM_DIR/versions/node/v${ver#v}*/bin(Nn))
    else
      dirs=($NVM_DIR/versions/node/*/bin(Nn))
    fi
    (( $#dirs )) && path=($dirs[-1] $path)
  }

  _load_nvm() {
    unfunction nvm 2>/dev/null
    source "$NVM_DIR/nvm.sh"
    [[ -s "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion"
  }

  nvm() {
    _load_nvm
    nvm "$@"
  }

  # .nvmrc auto-switch: cheap upward file search — nvm itself is only loaded
  # when an .nvmrc is actually found.
  _nvmrc_dir() {  # print the nearest ancestor of $1 containing .nvmrc
    local dir=$1
    while [[ -n "$dir" ]]; do
      [[ -f "$dir/.nvmrc" ]] && { print -r -- "$dir"; return 0 }
      dir=${dir%/*}
    done
    return 1
  }

  autoload -U add-zsh-hook
  load-nvmrc() {
    local nvmrc_dir
    if nvmrc_dir=$(_nvmrc_dir "$PWD"); then
      (( $+functions[nvm_find_nvmrc] )) || _load_nvm
      local want=$(nvm version "$(<$nvmrc_dir/.nvmrc)")
      if [[ "$want" == "N/A" ]]; then
        nvm install
      elif [[ "$want" != "$(nvm version)" ]]; then
        nvm use
      fi
    # revert to default only when leaving an .nvmrc dir (not on every cd, so a
    # manual `nvm use` elsewhere survives), and only if nvm is loaded at all
    elif (( $+functions[nvm_find_nvmrc] )) && _nvmrc_dir "$OLDPWD" >/dev/null &&
        [[ "$(nvm version)" != "$(nvm version default)" ]]; then
      echo "Reverting to nvm default version"
      nvm use default
    fi
  }
  add-zsh-hook chpwd load-nvmrc
  load-nvmrc
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

if (( $+commands[pm2] )); then
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

# bun completions
[ -s "/Users/yang/.bun/_bun" ] && source "/Users/yang/.bun/_bun"


export CLAUDE_CODE_ENABLE_AUTO_MODE=1

# Bedrock 起動。変数は claude プロセスにだけ渡し、シェルには残さない
# （export だと一度実行したシェルで claude がずっと Bedrock 課金になる）
cc-bedrock() {
  AWS_PROFILE=claude-bedrock \
  CLAUDE_CODE_USE_BEDROCK=1 \
  AWS_REGION=ap-northeast-1 \
  ANTHROPIC_DEFAULT_OPUS_MODEL='jp.anthropic.claude-opus-4-8' \
  ANTHROPIC_DEFAULT_SONNET_MODEL='jp.anthropic.claude-sonnet-4-6' \
  ANTHROPIC_DEFAULT_HAIKU_MODEL='jp.anthropic.claude-haiku-4-5-20251001-v1:0' \
  claude "$@"
}

# 素の claude = Pro。cc-bedrock が変数を漏らさないので unset は不要
cc-pro() { claude "$@"; }

# Public IP geolocation on startup {{{
# Prints a cached one-line summary instantly, then refreshes the cache in the
# background so the prompt is never blocked on the network (matters under p10k
# instant prompt). Source: ipinfo.io. Manual refresh: `ipgeo`.
_ipinfo_cache="${XDG_CACHE_HOME:-$HOME/.cache}/ipinfo.json"

_ipinfo_refresh() {
  curl -fsS --max-time 5 "https://ipinfo.io/json" -o "$_ipinfo_cache.tmp" \
    && mv "$_ipinfo_cache.tmp" "$_ipinfo_cache" \
    || rm -f "$_ipinfo_cache.tmp"
}

_ipinfo_show() {
  [[ -f "$_ipinfo_cache" ]] || return 0
  jq -r '"🌐 \(.ip)  \(.city), \(.region), \(.country)  (\(.org))"' \
    "$_ipinfo_cache" 2>/dev/null
}

ipgeo() { _ipinfo_refresh && _ipinfo_show; }

# Show cached value now, refresh for next time (only in interactive shells).
if [[ -o interactive ]]; then
  _ipinfo_show
  ( _ipinfo_refresh & ) >/dev/null 2>&1
fi
# }}}

# Geek terminal title: "~/cwd  🌿 branch" {{{
# tmux's set-titles-string can't expand a nested #{pane_current_path} inside
# #(...), so instead each pane sets its own title here and tmux forwards it
# (as #T). DISABLE_AUTO_TITLE (set in the omz config section above) keeps
# oh-my-zsh's command-name auto-title from fighting us.
_geek_title() {
  local dir="${PWD/#$HOME/~}"
  local branch
  branch=$(git symbolic-ref --short -q HEAD 2>/dev/null)
  local title="$dir"
  [[ -n "$branch" ]] && title+="  🌿 $branch"
  # OSC 2 sets the title. Inside tmux this becomes the pane title (#T), which
  # set-titles-string forwards to the outer terminal; outside tmux it sets the
  # window title directly.
  print -Pn "\e]2;${title}\a"
}
precmd_functions+=(_geek_title)
# }}}

