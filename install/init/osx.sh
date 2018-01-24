# OSX-only stuff. Abort if not OSX.
is_osx || return 1

# Install Homebrew.
if [[ ! "$(type -P brew)" ]]; then
  e_header "Installing Homebrew"
  true | ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Exit if, for some reason, Homebrew is not installed.
[[ ! "$(type -P brew)" ]] && e_error "Homebrew failed to install." && return 1

e_header "Updating Homebrew"
brew doctor
brew update

# Functions used in subsequent init scripts.

# Tap Homebrew kegs.
function brew_tap_kegs() {
  kegs=($(setdiff "${kegs[*]}" "$(brew tap)"))
  if (( ${#kegs[@]} > 0 )); then
    e_header "Tapping Homebrew kegs: ${kegs[*]}"
    for keg in "${kegs[@]}"; do
      brew tap $keg
    done
  fi
}

# Install Homebrew recipes.
function brew_install_recipes() {
  recipes=($(setdiff "${recipes[*]}" "$(brew list)"))
  if (( ${#recipes[@]} > 0 )); then
    e_header "Installing Homebrew recipes: ${recipes[*]}"
    for recipe in "${recipes[@]}"; do
      brew install $recipe
    done
  fi
}

# Ensure the cask kegs are installed.
kegs=(
  caskroom/cask
  caskroom/drivers
  caskroom/fonts
)
brew_tap_kegs

# Hack to show the first-run brew-cask password prompt immediately.
brew cask info this-is-somewhat-annoying 2>/dev/null

# Homebrew casks
casks=(
  # Applications
  # a-better-finder-rename
  # alfred
  # android-platform-tools
  # bartender
  # battle-net
  # bettertouchtool
  # charles
  # chromium
  # chronosync
  # controllermate
  # docker
  # dropbox
  # fastscripts
  # firefox
  # gyazo
  # hex-fiend
  # iterm2
  # karabiner-elements
  # macvim
  # messenger-for-desktop
  # midi-monitor
  # moom
  # omnidisksweeper
  # race-for-the-galaxy
  # reaper
  # robo-3t
  # screenhero
  # scroll-reverser
  # skype
  # slack
  # sourcetree
  # spotify
  # steam
  # the-unarchiver
  # totalfinder
  # tower
  # vagrant
  # virtualbox
  # vlc
  # ynab
  # # Quick Look plugins
  # betterzipql
  # qlcolorcode
  # qlmarkdown
  # qlprettypatch
  # qlstephen
  # quicklook-csv
  # quicklook-json
  # quicknfo
  # suspicious-package
  # webpquicklook
  # # Color pickers
  # colorpicker-developer
  # colorpicker-skalacolor
  # # Drivers
  # sonos
  # xbox360-controller-driver
  # # Fonts
  # font-m-plus
  # font-mplus-nerd-font
  # font-mplus-nerd-font-mono
)

# Install Homebrew casks.
casks=($(setdiff "${casks[*]}" "$(brew cask list 2>/dev/null)"))
if (( ${#casks[@]} > 0 )); then
  e_header "Installing Homebrew casks: ${casks[*]}"
  for cask in "${casks[@]}"; do
    brew cask install $cask
  done
  brew cask cleanup
fi

# Homebrew recipes
recipes=(
  # ansible
  # awscli
  # zsh
  # cmatrix
  # coreutils
  # cowsay
  # git
  # git-extras
  # htop-osx
  # hub
  # id3tool
  # jq
  # lesspipe
  # man2html
  # mercurial
  # nmap
  # postgresql
  # reattach-to-user-namespace
  # sl
  # ssh-copy-id
  # terminal-notifier
  # the_silver_searcher
  # tmux
  # tree
  # wget
)

brew_install_recipes

# Misc cleanup!

# This is where brew stores its binary symlinks
local binroot="$(brew --config | awk '/HOMEBREW_PREFIX/ {print $2}')"/bin

# htop
if [[ "$(type -P $binroot/htop)" ]] && [[ "$(stat -L -f "%Su:%Sg" "$binroot/htop")" != "root:wheel" || ! "$(($(stat -L -f "%DMp" "$binroot/htop") & 4))" ]]; then
  e_header "Updating htop permissions"
  sudo chown root:wheel "$binroot/htop"
  sudo chmod u+s "$binroot/htop"
fi

# zsh
if [[ "$(type -P $binroot/zsh)" && "$(cat /etc/shells | grep -q "$binroot/zsh")" ]]; then
  e_header "Adding $binroot/zsh to the list of acceptable shells"
  echo "$binroot/zsh" | sudo tee -a /etc/shells >/dev/null
fi

if [[ "$(dscl . -read ~ UserShell | awk '{print $2}')" != "$binroot/zsh" ]]; then
  e_header "Making $binroot/zsh your default shell"
  sudo chsh -s "$binroot/zsh" "$USER" >/dev/null 2>&1
  e_arrow "Please exit and restart all your shells."
fi
