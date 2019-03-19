#!/usr/bin/env zsh

source "$(dirname "$0")/util.sh"

e_header "Global npm packages"

npm update -g

PACKAGES=(
  diff-so-fancy
  intelephense
  typescript
  tldr
  neovim
  fixjson
)

npm install -g ${PACKAGES[@]}
