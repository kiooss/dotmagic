#!/usr/bin/env bash

FILES="$DOTFILES/resources/terminfo/*.terminfo"
for f in $FILES; do
  echo "Processing $f file..."
  tic "$f"
done
