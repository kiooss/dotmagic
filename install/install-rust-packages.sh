#!/usr/bin/env zsh

# https://doc.rust-lang.org/cargo/getting-started/installation.html

source "$(dirname "$0")/util.sh"

e_header "Global rust packages"

PACKAGES=(
  exa
  # lsd
  ripgrep
  fd-find
)

cargo install ${PACKAGES[@]}
