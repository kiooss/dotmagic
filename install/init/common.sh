#!/bin/bash

# create dirs
mkdir -p ~/bin
mkdir -p ~/.cache
mkdir -p ~/.config
mkdir -p ~/.local

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
    git clone https://github.com/andorchen/rbenv-china-mirror.git "$RBENV_ROOT"/plugins/rbenv-china-mirror
    git clone https://github.com/rkh/rbenv-update.git "$RBENV_ROOT"/plugins/rbenv-update
    cat <<EOT >> "$RBENV_ROOT"/default-gems
bundler
awesome_print
pry
lolcat
git-up
EOT
fi

# install pyenv
PYENV_ROOT="$HOME/.pyenv"
if [ -d "$PYENV_ROOT" ]; then
    e_error "pyenv already exists... Skipping."
else
    e_info "Installing pyenv"
    git clone https://github.com/pyenv/pyenv.git "$PYENV_ROOT"
    git clone https://github.com/pyenv/pyenv-virtualenv.git "$PYENV_ROOT/plugins/pyenv-virtualenv"
    git clone git://github.com/yyuu/pyenv-update.git "$PYENV_ROOT/plugins/pyenv-update"
fi

# install dasht
if [ -d "$HOME/.dasht" ]; then
    e_error "dasht already exists... Skipping."
else
    e_info "Installing dasht"
    git clone https://github.com/sunaku/dasht ~/.dasht
fi

# install node
export N_PREFIX=$HOME/.n
if [ -d "$N_PREFIX" ]; then
    e_error "n already exists... Skipping."
else
    e_info "Installing node via n"
    cd ~
    curl -L https://raw.githubusercontent.com/tj/n/master/bin/n -o n
    bash n lts
fi

# install phppbrew
if [ -d "$HOME/.phpbrew" ]; then
    e_error "phpbrew already exists... Skipping."
else
    e_info "Installing phpbrew"
    cd ~/bin
    curl -L -O https://github.com/phpbrew/phpbrew/releases/latest/download/phpbrew.phar
    chmod +x phpbrew.phar
    mv phpbrew.phar phpbrew
fi
