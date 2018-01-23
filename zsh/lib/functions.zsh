function upgrade_dotfiles() {
  env DOTFILES=$DOTFILES sh $DOTFILES/install/upgrade.sh
}

function link_dotfiles() {
  env DOTFILES=$DOTFILES sh $DOTFILES/install/link.sh $@
}
