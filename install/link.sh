#!/bin/bash

DOTFILES=$HOME/.dotfiles

force="$1"

printf "\n${YELLOW}Creating symlinks\n"
printf "===========================================================${NORMAL}\n"
linkables=$( find -H "$DOTFILES/link" -maxdepth 3 -name '*.symlink' )
for file in $linkables ; do
    target="$HOME/.$( basename $file ".symlink" )"
    if [ -e "$target" ]; then
        if [ "$force" = "force" ]; then
            echo "~${target#$HOME} already exists... Creating it forcelly."
            ln -sf "$file" "$target"
        else
            echo "~${target#$HOME} already exists... Skipping."
        fi
    else
        echo "Creating symlink for $file"
        ln -sf "$file" "$target"
    fi
done

: '
echo -e "\n\ninstalling to ~/.config"
echo "=============================="
if [ ! -d $HOME/.config ]; then
    echo "Creating ~/.config"
    mkdir -p $HOME/.config
fi
# configs=$( find -path "$DOTFILES/config.symlink" -maxdepth 1 )
for config in $DOTFILES/config/*; do
    target=$HOME/.config/$( basename $config )
    if [ -e $target ]; then
        echo "~${target#$HOME} already exists... Skipping."
    else
        echo "Creating symlink for $config"
        ln -s $config $target
    fi
done
'
