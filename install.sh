#!/bin/bash

main() {
    # Use colors, but only if connected to a terminal, and that terminal
    # supports them.
    if which tput >/dev/null 2>&1; then
        ncolors=$(tput colors)
    fi
    if [ -t 1 ] && [ -n "$ncolors" ] && [ "$ncolors" -ge 8 ]; then
      RED="$(tput setaf 1)"
      GREEN="$(tput setaf 2)"
      YELLOW="$(tput setaf 3)"
      BLUE="$(tput setaf 4)"
      BOLD="$(tput bold)"
      NORMAL="$(tput sgr0)"
    else
      RED=""
      GREEN=""
      YELLOW=""
      BLUE=""
      BOLD=""
      NORMAL=""
    fi

    set -o errexit
    set -o pipefail
    set -o nounset

    printf "${BLUE}Installing dotfiles.${NORMAL}\n"

    #echo "Initializing submodule(s)"
    #git submodule update --init --recursive

    source install/pre.sh
    source install/link.sh

    : '
    if [ "$(uname)" == "Darwin" ]; then
        echo "Running on OSX"

        echo "Brewing all the things"
        source install/brew.sh

        echo "Updating OSX settings"
        source installosx.sh

        echo "Installing node (from nvm)"
        source install/nvm.sh

        echo "Configuring nginx"
        # create a backup of the original nginx.conf
        mv /usr/local/etc/nginx/nginx.conf /usr/local/etc/nginx/nginx.original
        ln -s ~/.dotfiles/nginx/nginx.conf /usr/local/etc/nginx/nginx.conf
        # symlink the code.dev from dotfiles
        ln -s ~/.dotfiles/nginx/code.dev /usr/local/etc/nginx/sites-enabled/code.dev
    fi
    '

    echo "creating vim directories"
    mkdir -p ~/.vim-tmp

    if [ -n "`$SHELL -c 'echo $ZSH_VERSION'`" ]; then
        # assume Zsh
        :
    else
        # asume something else
        printf "${YELLOW}Configuring zsh as default shell${NORMAL}\n"
        chsh -s $(which zsh)
    fi

    printf "${GREEN}Done.${NORMAL}\n"

    # restart shell
    printf "${YELLOW}restarting shell${NORMAL}\n"
    exec $SHELL -l
}

main
