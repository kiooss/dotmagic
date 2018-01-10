#!/bin/bash

printf "\n${YELLOW}Pre install\n"
printf "==============================${NORMAL}\n"

if hash apt-get 2>/dev/null; then
    # install some necessary packages
    sudo apt-get install autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm3 libgdbm-dev grc libncursesw5-dev -y
    sudo apt-get install curl libjpeg-dev libpng12-dev openssl libssl-dev libcurl4-openssl-dev pkg-config libsslcommon2-dev libreadline-dev libedit-dev libicu-dev libxml2-dev gettext libpq-dev -y


    # install zsh
    if hash zsh 2>/dev/null; then
        echo "Zsh already exists... Skipping."
    else
        echo "Installing zsh."
        sudo apt-get install zsh -y
    fi

    # install ctags
    if hash ctags 2>/dev/null; then
        echo "ctags already exists... Skipping."
    else
        echo "Installing ctags."
        sudo apt-get install ctags -y
    fi
fi

# install dircolors-solarized
if [ -d "$HOME/.dircolors-solarized" ]; then
    echo "dircolors-solarized already exists... Skipping."
else
    echo "Installing dircolors-solarized"
    git clone https://github.com/seebi/dircolors-solarized ~/.dircolors-solarized
    ln -s ~/.dircolors-solarized/dircolors.256dark ~/.dircolors
fi

# install base16-shell
if [ -d "$HOME/.config/base16-shell" ]; then
    echo "base16-shell already exists... Skipping."
else
    echo "Installing base16-shell"
    git clone https://github.com/chriskempson/base16-shell ~/.config/base16-shell
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
    echo "Installing ruby-build"
    git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
fi

# install pyenv
if [ -d "$HOME/.pyenv" ]; then
    echo "pyenv already exists... Skipping."
else
    echo "Installing pyenv"
    curl -L https://raw.githubusercontent.com/yyuu/pyenv-installer/master/bin/pyenv-installer | bash
fi

# install tpm
if [ -d "$HOME/.tmux/plugins/tpm" ]; then
    echo "tpm already exists... Skipping."
else
    echo "Installing tmp"
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi
