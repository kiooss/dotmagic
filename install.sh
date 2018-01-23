if which tput >/dev/null 2>&1; then
  ncolors=$(tput colors)
fi

if [ -t 1 ] && [ -n "$ncolors" ] && [ "$ncolors" -ge 8 ]; then
  BLACK="$(tput setaf 0)"
  RED="$(tput setaf 1)"
  GREEN="$(tput setaf 2)"
  YELLOW="$(tput setaf 3)"
  BLUE="$(tput setaf 4)"
  MAGENTA="$(tput setaf 5)"
  CYAN="$(tput setaf 6)"
  WHITE="$(tput setaf 7)"
  BOLD="$(tput bold)"
  NORMAL="$(tput sgr0)"
else
  BLACK=""
  RED=""
  GREEN=""
  YELLOW=""
  BLUE=""
  MAGENTA=""
  CYAN=""
  WHITE=""
  BOLD=""
  NORMAL=""
fi

e_section() {
  printf "\n${BLUE}$@\n"
  printf "=================================================================${NORMAL}\n"
}

e_success() {
  printf "${GREEN}✔${NORMAL} $@\n"
}

e_error() {
  printf "${RED}✖${NORMAL} $@\n"
}

e_info() {
  printf "${YELLOW}➜${NORMAL} $@\n"
}

big_title() {
  printf "%s" "$GREEN"
  printf '%s\n' ' _    _                           _       _    __ _ _'
  printf '%s\n' '| | _(_) ___   ___  ___ ___    __| | ___ | |_ / _(_) | ___  ___'
  printf '%s\n' '| |/ / |/ _ \ / _ \/ __/ __|  / _` |/ _ \| __| |_| | |/ _ \/ __|'
  printf '%s\n' '|   <| | (_) | (_) \__ \__ \ | (_| | (_) | |_|  _| | |  __/\__ \'
  printf '%s\n' '|_|\_\_|\___/ \___/|___/___/  \__,_|\___/ \__|_| |_|_|\___||___/'
  printf "%s" "$NORMAL"
}

main() {

  set -o errexit
  # set -o pipefail
  # set -o nounset

  big_title
  e_section "Installing kiooss dotfiles."

  if [ ! -n "$DOTFILES" ]; then
    DOTFILES=~/.dotfiles
  fi


  # Prevent the cloned repository from having insecure permissions. Failing to do
  # so causes compinit() calls to fail with "command not found: compdef" errors
  # for users with insecure umasks (e.g., "002", allowing group writability). Note
  # that this will be ignored under Cygwin by default, as Windows ACLs take
  # precedence over umasks except for filesystems mounted with option "noacl".
  umask g-w,o-w

  hash git >/dev/null 2>&1 || {
    e_error "Error: git is not installed"
    exit 1
  }

  if [ ! -d "$DOTFILES" ]; then
    e_info "Cloning kiooss dotfiles"
    git clone https://github.com/kiooss/dotmagic $DOTFILES
  fi

  e_info "Initializing submodule(s)"
  git submodule update --init --recursive

  cd $DOTFILES

  . install/pre.sh
  . install/link.sh

  if [ -n "`$SHELL -c 'echo $ZSH_VERSION'`" ]; then
    # assume Zsh
    :
  else
    # asume something else
    printf "${YELLOW}%s${NORMAL}\n" "Configuring zsh as default shell"
    chsh -s "$(which zsh)"
  fi

  e_info "All Done."

  # restart shell
  e_info "Restarting shell"
  exec "$SHELL" -l
}

main
