#!/bin/bash

DOTFILES=$HOME/.dotfiles

. "$DOTFILES/install/util.sh"

big_title
e_section "Updating Dotfiles."
e_info "Dotfiles's dir: $DOTFILES"

cd "$DOTFILES"
prev_head="$(git rev-parse HEAD)"

git pull --rebase --stat --autostash origin master
git submodule update --init --recursive

if [[ "$(git rev-parse HEAD)" != "$prev_head" ]]; then
  e_info "Changes detected, please reload shell."
fi

e_success "Hooray! Dotfiles has been updated and/or is at the current version."
