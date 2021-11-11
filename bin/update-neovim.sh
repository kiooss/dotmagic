#!/usr/bin/env bash

set -x

killall nvim

if [[ $OSTYPE == 'darwin'* ]]; then
  echo 'macOS'
  cd "$HOME/bin" || exit
  curl -L https://github.com/neovim/neovim/releases/download/nightly/nvim-macos.tar.gz -o nvim-macos.tar.gz
  curl -L https://github.com/neovim/neovim/releases/download/nightly/nvim-macos.tar.gz.sha256sum -o nvim-macos.tar.gz.sha256sum
  sha256sum --check nvim-macos.tar.gz.sha256sum || exit
  tar xzvf nvim-macos.tar.gz
  ln -sfn ./nvim-osx64/bin/nvim nvim
else
  echo 'Linux'
  cd "$HOME/bin" || exit
  curl -L https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage -o nvim.appimage
  curl -L https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage.sha256sum -o nvim.appimage.sha256sum
  sha256sum --check nvim.appimage.sha256sum || exit
fi
