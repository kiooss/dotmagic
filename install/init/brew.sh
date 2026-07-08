# mac-only stuff. Abort if not macOS
is_mac || return 1

# Install Homebrew.
if [[ ! "$(type -P brew)" ]]; then
  e_info "Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Exit if, for some reason, Homebrew is not installed.
[[ ! "$(type -P brew)" ]] && e_error "Homebrew failed to install." && return 1

e_info "Updating Homebrew"
brew update

# Install everything declared in the Brewfile. The Brewfile is the single
# source of truth for taps/brews/casks — add packages there, not here.
e_info "Installing packages from Brewfile"
brew bundle --file="$DOTFILES/Brewfile"

e_info "Running Homebrew cleanup"
brew cleanup
