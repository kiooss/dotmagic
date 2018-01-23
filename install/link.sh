#!/bin/bash

DOTFILES=$HOME/.dotfiles

if [ -z "$YELLOW" ]; then
    source "$DOTFILES/install/color.sh"
fi

force="$1"

printf "\n${YELLOW}Creating symlinks\n"
printf "===========================================================${NORMAL}\n"
linkables=$( find -H "$DOTFILES/link" -maxdepth 3 -name '*.symlink' )
for file in $linkables ; do
    target="$HOME/.$( basename $file ".symlink" )"
    if [ -e "$target" ]; then
        if [ "$force" = "force" ]; then
            printf "%s~%s%s already exists... %sCreating it forcelly!%s\n" "$GREEN" "${target#$HOME}" "$NORMAL" "$RED" "$NORMAL"
            rm "$target" && ln -s "$file" "$target"
        else
            printf "%s~%s%s already exists... %sSkipping%s\n" "$GREEN" "${target#$HOME}" "$NORMAL" "$BLUE" "$NORMAL"
        fi
    else
        printf "Creating symlink for %s%s%s\n" "$GREEN" "$file" "$NORMAL"
        ln -sf "$file" "$target"
    fi
done
printf "${YELLOW}Symlinks created success${NORMAL}\n"
