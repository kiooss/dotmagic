#!/bin/bash

echo -e "\nPre install"
echo "=============================="

# install dircolors-solarized
if [ -d "$HOME/dircolors-solarized" ]; then
    echo "dircolors-solarized already exists... Skipping."
else
    echo "Installing dircolors-solarized"
    git clone https://github.com/seebi/dircolors-solarized ~/dircolors-solarized
    ln -s ~/dircolors-solarized/dircolors.256dark ~/.dircolors
fi

# install oh-my-zsh
if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "oh-my-zsh already exists... Skipping."
else
    echo "Installing on-my-zsh"
    git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
fi

# install rbenv
if [ -d "$HOME/.rbenv" ]; then
    echo "rbenv already exists... Skipping."
else
    echo "Installing rbenv"
    git clone https://github.com/rbenv/rbenv.git ~/.rbenv
fi
