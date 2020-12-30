#!/usr/bin/env zsh

# https://doc.rust-lang.org/cargo/getting-started/installation.html
# curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

source "$(dirname "$0")/util.sh"

e_header "update both Rust and Cargo"

rustup update stable

e_header "Global rust packages"

PACKAGES=(
  exa
  # lsd
  ripgrep
  fd-find
)

cargo install ${PACKAGES[@]}
