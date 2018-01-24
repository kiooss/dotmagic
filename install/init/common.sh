#!/bin/bash

# install oh-my-zsh
if [ -d "$HOME/.oh-my-zsh" ]; then
    e_error "oh-my-zsh already exists... Skipping."
else
    e_info "Installing on-my-zsh"
    git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
fi
