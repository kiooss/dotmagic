#!/usr/bin/env bash

main() {
  # set -o errexit
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

  e_header "Initializing submodule(s)"
  git submodule update --init --recursive
  e_success "done."

  e_header "Install necessary lib and apps."
  if is_osx; then
    e_info "System is osx."
    . install/init/osx.sh
  elif is_ubuntu; then
    e_info "System is ubuntu."
    . install/init/ubuntu.sh
  fi
  e_success "done."

  . install/link.sh

  # if [ -n "`$SHELL -c 'echo $ZSH_VERSION'`" ]; then
  #   # assume Zsh
  #   :
  # else
  #   # asume something else
  #   e_info "Configuring zsh as default shell"
  #   chsh -s "$(which zsh)"
  # fi

  e_header "Welcome to the kiooss dotfiles world!"
  big_title
  printf "\n"
  e_success "The kiooss dotfiles is now installed."
  printf "\n"

  # restart shell
  # e_info "Restarting shell"
  # exec "$SHELL" -l
}

main
