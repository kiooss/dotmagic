#!/usr/bin/env zsh

source "$(dirname "$0")/util.sh"

e_header "Global npm packages"

npm update -g

PACKAGES=(
  n
  diff-so-fancy
  intelephense
  typescript
  tldr
  neovim
  fixjson
  eslint
)

npm install -g ${PACKAGES[@]}
