#### install vim8.0 in ubuntu 16.04
sudo apt remove vim-tiny vim-common vim-gui-common vim-nox
sudo add-apt-repository ppa:jonathonf/vim
sudo apt update
sudo apt install vim

#### uninstall
sudo apt install ppa-purge && sudo ppa-purge ppa:jonathonf/vim
