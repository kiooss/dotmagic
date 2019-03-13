#### install vim8.0 in ubuntu 16.04
sudo apt remove vim-tiny vim-common vim-gui-common vim-nox
sudo add-apt-repository ppa:jonathonf/vim
sudo apt update
sudo apt install vim

#### uninstall
sudo apt install ppa-purge && sudo ppa-purge ppa:jonathonf/vim

#### vim runtime log to file
running vim with the -V[N] option will do a pretty hefty runtime log, here N is the debug level.

`
vim -V9myVim.log
`


#### coc.nvim
```
CocInstall coc-dictionary
CocInstall coc-word
CocInstall coc-emoji
CocInstall coc-ultisnips
CocInstall coc-tsserver
CocInstall coc-json
CocInstall coc-solargraph
```

