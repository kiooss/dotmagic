function upgrade_dotfiles() {
  git -C "$DOTFILES" pull --rebase --autostash origin master &&
    git -C "$DOTFILES" submodule update --init --recursive
}

function link_dotfiles() {
  env DOTFILES=$DOTFILES bash $DOTFILES/bin/dotlink sync $@
}
