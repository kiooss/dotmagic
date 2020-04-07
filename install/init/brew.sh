# mac-only stuff. Abort if not macOS
is_mac || return 1

# Install Homebrew.
if [[ ! "$(type -P brew)" ]]; then
  e_info "Installing Homebrew"
  true | ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Exit if, for some reason, Homebrew is not installed.
[[ ! "$(type -P brew)" ]] && e_error "Homebrew failed to install." && return 1

e_info "Running Homebrew doctor"
brew doctor

e_info "Running Homebrew cleanup."
brew cleanup

e_info "Updating Homebrew"
brew update

# Functions used in subsequent init scripts.

# brew tap
function brew_add_taps() {
  taps=($(setdiff "${taps[*]}" "$(brew tap)"))
  if (( ${#taps[@]} > 0 )); then
    e_info "Add Homebrew taps: ${taps[*]}"
    for tap in "${taps[@]}"; do
      brew tap $tap
    done
  fi
}

# Install Homebrew casks.
function brew_install_casks() {
  casks=($(setdiff "${casks[*]}" "$(brew cask list 2>/dev/null)"))
  if (( ${#casks[@]} > 0 )); then
    e_info "Installing Homebrew casks: ${casks[*]}"
    for cask in "${casks[@]}"; do
      brew cask install $cask
    done
    brew cask cleanup
  fi
}

# Install Homebrew recipes.
function brew_install_recipes() {
  recipes=($(setdiff "${recipes[*]}" "$(brew list)"))
  if (( ${#recipes[@]} > 0 )); then
    e_info "Installing Homebrew recipes: ${recipes[*]}"
    for recipe in "${recipes[@]}"; do
      brew install $recipe
    done
  fi
}

# Taps (Third-Party Repositories).
taps=(
  homebrew/cask-fonts
)

e_info "brew_add_taps"
brew_add_taps

# Hack to show the first-run brew-cask password prompt immediately.
brew cask info this-is-somewhat-annoying 2>/dev/null

# Homebrew casks
casks=(
  # Applications
  # a-better-finder-rename
  # android-platform-tools
  # bartender
  # battle-net
  # bettertouchtool
  # charles
  # chronosync
  # controllermate
  # docker
  # dropbox
  # fastscripts
  # firefox
  # gyazo
  # hex-fiend
  # macvim
  # moom
  # race-for-the-galaxy
  # reaper
  # robo-3t
  # screenhero
  # scroll-reverser
  # sourcetree
  accessmenubarapps
  alfred
  # docker
  kitematic
  iina
  iterm2
  itsycal
  intel-power-gadget # 监控CPU频率
  jmeter
  karabiner-elements
  kawa # https://github.com/utatti/kawa
  omnidisksweeper
  psequel
  quitter
  sequel-pro
  skype
  slack
  spectacle
  the-unarchiver
  timemachineeditor
  vagrant
  virtualbox
  wkhtmltopdf
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
  #### Fonts ####
  font-sarasa-gothic # 更纱黑体 / 更紗黑體 / 更紗ゴシック
  font-firacode-nerd-font # double-width (non-monospaced) glyphs
  font-firacode-nerd-font-mono # Monospaced (fixed-pitch, fixed-width) glyphs
  font-iosevka-nerd-font-mono
)

# Install Homebrew casks.
e_info "brew_install_casks"
brew_install_casks

# Homebrew recipes
recipes=(
  aria2
  automake
  autossh
  clipper
  cmake
  coreutils
  exa
  fd
  git
  highlight
  hub
  jq
  lesspipe
  neovim
  pass
  php
  pkg-config
  ripgrep
  terminal-notifier
  the_silver_searcher
  tmux
  todo-txt
  tree
  utf8proc
  wget
  yarn
  zsh
)

e_info "brew_install_recipes"
brew_install_recipes

# Misc cleanup!

# This is where brew stores its binary symlinks
local binroot="$(brew --config | awk '/HOMEBREW_PREFIX/ {print $2}')"/bin

# htop
if [[ "$(type -P $binroot/htop)" ]] && [[ "$(stat -L -f "%Su:%Sg" "$binroot/htop")" != "root:wheel" || ! "$(($(stat -L -f "%DMp" "$binroot/htop") & 4))" ]]; then
  e_info "Updating htop permissions"
  sudo chown root:wheel "$binroot/htop"
  sudo chmod u+s "$binroot/htop"
fi

# zsh
if [[ "$(type -P $binroot/zsh)" && "$(cat /etc/shells | grep -q "$binroot/zsh")" ]]; then
  e_info "Adding $binroot/zsh to the list of acceptable shells"
  echo "$binroot/zsh" | sudo tee -a /etc/shells >/dev/null
fi

if [[ "$(dscl . -read ~ UserShell | awk '{print $2}')" != "$binroot/zsh" ]]; then
  e_info "Making $binroot/zsh your default shell"
  sudo chsh -s "$binroot/zsh" "$USER" >/dev/null 2>&1
  e_arrow "Please exit and restart all your shells."
fi
