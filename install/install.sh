#!/usr/bin/env bash

main() {
  set -o errexit
  # set -o pipefail
  # set -o nounset

  if [ ! -n "$DOTFILES" ]; then
    DOTFILES=~/.dotfiles
  fi

  # Prevent the cloned repository from having insecure permissions. Failing to do
  # so causes compinit() calls to fail with "command not found: compdef" errors
  # for users with insecure umasks (e.g., "002", allowing group writability). Note
  # that this will be ignored under Cygwin by default, as Windows ACLs take
  # precedence over umasks except for filesystems mounted with option "noacl".
  umask g-w,o-w

  hash git >/dev/null 2>&1 || {
    echo "Error: git is not installed"
    exit 1
  }

  if [ ! -d "$DOTFILES" ]; then
    echo "Cloning kiooss dotfiles"
    git clone https://github.com/kiooss/dotmagic $DOTFILES
  fi

  cd $DOTFILES
  . install/util.sh

  e_info "Initializing submodule(s)"
  git submodule update --init --recursive

  if is_osx; then
    . install/init/osx.sh
  elif is_ubuntu; then
    . install/init/ubuntu.sh
  fi

  . install/link.sh

  if [ -n "`$SHELL -c 'echo $ZSH_VERSION'`" ]; then
    # assume Zsh
    :
  else
    # asume something else
    e_info "Configuring zsh as default shell"
    chsh -s "$(which zsh)"
  fi

  big_title
  e_success "The kiooss dotfiles is now installed."

  # restart shell
  e_info "Restarting shell"
  exec "$SHELL" -l
}

main
