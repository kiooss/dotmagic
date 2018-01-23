function upgrade_dotfiles() {
  env DOTFILES=$DOTFILES bash $DOTFILES/install/upgrade.sh
}

function link_dotfiles() {
  env DOTFILES=$DOTFILES bash $DOTFILES/install/link.sh $@
}
