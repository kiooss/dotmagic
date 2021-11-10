#!/usr/bin/env bash

killall -q nvim
curl -L https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage -o "$HOME/bin/nvim.appimage"
