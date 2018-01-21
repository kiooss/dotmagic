function upgrade_dotfiles() {
  env DOTFILES=$DOTFILES sh $DOTFILES/install/upgrade.sh
}
