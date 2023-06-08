#!/usr/bin/env bash

link_config() {
  config="$1"
  link_name="$2"
  echo "-> config: $config link_name: $link_name"
  if [ -e "$link_name" ]; then
    if ! [ "$link_name" -ef "$config" ]; then
      if [ "$force" = "force" ]; then
        echo "❗️${link_name} already exists, backup it and do link staff."
        mv "$link_name" "$BACKUP_DIR/"
        ln -sf "$config" "$link_name"
        echo "✅ Linked $config to $link_name"
      else
        echo "⚠️  ${link_name} already exists, skip."
      fi
    else
      echo "🔗 ${link_name} already linked."
    fi
  else
    ln -sf "$config" "$link_name"
    echo "✅ Linked $config to $link_name"
  fi
}

DOTFILES=$HOME/.dotfiles
BACKUP_DIR=$HOME/.backup

[ ! -d "$BACKUP_DIR" ] && mkdir -p "$BACKUP_DIR"

force="$1"
[ "$force" = "force" ] && echo "!!!Run in force mode, be careful."

printf "\n👉 Linking files into home directory.\n"
find -H "$DOTFILES/link" -maxdepth 3 -name '*.symlink' -print0 | while read -r -d $'\0' config; do
  link_name="$HOME/.$(basename "$config" '.symlink')"
  link_config "$config" "$link_name"
done

printf "\n👉 Linking files into ~/.config directory.\n"
find -H "$DOTFILES/dotconfig" -maxdepth 1 -mindepth 1 -type d -print0 | while read -r -d $'\0' config; do
  link_name="$HOME/.config/$(basename "$config")"
  link_config "$config" "$link_name"
done

if [ "$(uname -s)" == "Darwin" ]; then
  printf "\n👉 Linking mac specific config into ~/.config directory.\n"
  find -H "$DOTFILES/config.mac" -maxdepth 1 -mindepth 1 -type d -print0 | while read -r -d $'\0' config; do
    link_name="$HOME/.config/$(basename "$config")"
    link_config "$config" "$link_name"
  done
fi

printf "\n✨ done.\n"
