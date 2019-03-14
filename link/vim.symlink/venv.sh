#!/usr/bin/env bash

# virtual environments for neovim.
# pip2 install --user virtualenv

set -ex

# Declare a base path for both virtual environments
venv="${XDG_CACHE_HOME:-$HOME/.cache}/vim/venv"

PY3=python3.6

# Try to detect python2/3 executables
if ! hash python2 2>/dev/null; then
	echo "Python2 installation not found."
	exit 1
elif ! hash $PY3 2>/dev/null; then
	echo "Python3 installation not found."
	exit 1
fi

# Ensure python 2/3 virtual environments
[ -d "$venv" ] || mkdir -p "$venv"
[ -d "$venv/neovim2" ] || python2 -m virtualenv "$venv/neovim2"
[ -d "$venv/neovim3" ] || $PY3 -m venv "$venv/neovim3"

# Install or upgrade dependencies
echo ':: PYTHON 2'
"$venv/neovim2/bin/pip" install -U pip
"$venv/neovim2/bin/pip" install -U neovim PyYAML solargraph-utils.py
echo -e '\n:: PYTHON 3'
"$venv/neovim3/bin/pip" install -U pip
"$venv/neovim3/bin/pip" install -U pynvim
