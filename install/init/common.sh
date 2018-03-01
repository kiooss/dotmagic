#!/bin/bash

# install oh-my-zsh
if [ -d "$HOME/.oh-my-zsh" ]; then
    e_error "oh-my-zsh already exists... Skipping."
else
    e_info "Installing on-my-zsh"
    git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
fi

# install rbenv
RBENV_ROOT="$HOME/.rbenv"
if [ -d "$RBENV_ROOT" ]; then
    e_error "rbenv already exists... Skipping."
else
    e_info "Installing rbenv"
    git clone https://github.com/rbenv/rbenv.git "$RBENV_ROOT"
    cd "$RBENV_ROOT" && src/configure && make -C src

    git clone https://github.com/carsomyr/rbenv-bundler.git "$RBENV_ROOT"/plugins/bundler
    git clone https://github.com/rbenv/ruby-build.git "$RBENV_ROOT"/plugins/ruby-build
    git clone https://github.com/rbenv/rbenv-default-gems.git "$RBENV_ROOT"/plugins/rbenv-default-gems
    cat <<EOT >> "$RBENV_ROOT"/default-gems
bundler
awesome_print
pry
lolcat
git-up
EOT
fi
