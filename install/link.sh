#!/bin/bash

DOTFILES=$HOME/.dotfiles
BACKUP_DIR=$HOME/.backup

[ ! -d "$BACKUP_DIR" ] && mkdir -p "$BACKUP_DIR"

. "$DOTFILES/install/util.sh"

force="$1"

e_header "Linking files into home directory."
[ "$force" = "force" ] && e_info "Run in force mode, be careful."

linkables=$( find -H "$DOTFILES/link" -maxdepth 3 -name '*.symlink' )

for file in $linkables ; do
  target="$HOME/.$(basename $file '.symlink')"
  e_info "Target: ${target}"
  if [ -e "$target" ]; then
    if ! [ "$target" -ef "$file" ]; then
      if [ "$force" = "force" ]; then
        e_error "${target} already exists, backup it and do link staff."
        mv "$target" "$BACKUP_DIR/"
        e_success "Linking $file to $target"
        ln -sf "$file" "$target"
      else
        e_error "${target} already exists, skip."
      fi
    else
      echo 'Already linked.'
    fi
  else
    e_success "Linking $file to $target"
    ln -sf "$file" "$target"
  fi
done

# for neovim
e_info "Target: $HOME/.config/nvim"
if [ -e "$HOME/.config/nvim" ]; then
  if ! [ "$DOTFILES/link/vim.symlink" -ef "$HOME/.config/nvim" ]; then
    e_error "$HOME/.config/nvim already exists, skip."
  else
    echo 'Already linked.'
  fi
else
  e_success "Linking $DOTFILES/link/vim.symlink to $HOME/.config/nvim"
  ln -sf "$DOTFILES/link/vim.symlink" "$HOME/.config/nvim"
fi

e_success "done."
