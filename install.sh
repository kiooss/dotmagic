#!/bin/bash

echo "Installing dotfiles"

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
    echo "Configuring zsh as default shell"
    chsh -s $(which zsh)
fi


# restart shell
echo "restarting shell"
exec $SHELL -l

echo "Done."
