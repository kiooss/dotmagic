# Ubuntu-only stuff. Abort if not Ubuntu.
is_ubuntu || return 1

apt_packages=()
apt_source_files=()
apt_source_texts=()

# Ubuntu distro release name, eg. "xenial"
release_name=$(lsb_release -c | awk '{print $2}')

function add_ppa() {
  apt_source_texts+=($1)
  IFS=':/' eval 'local parts=($1)'
  apt_source_files+=("${parts[1]}-ubuntu-${parts[2]}-$release_name")
}

# Misc.
apt_packages+=(
  acpi # to get the battery info.
  build-essential
  cowsay
  curl
  figlet
  gettext
  grc
  htop
  imagemagick
  jq
  libboost-program-options-dev
  libcurl4-openssl-dev
  libedit-dev
  libicu-dev
  libjpeg-dev
  libncursesw5-dev
  libpng12-dev
  libpq-dev
  libreadline-dev
  libssl-dev
  libsslcommon2-dev
  libxml2-dev
  nmap
  openssl
  pkg-config
  python-pip
  silversearcher-ag
  todotxt-cli
  tree
)

# apt_packages+=(vim)

# https://github.com/neovim/neovim/wiki/Installing-Neovim
add_ppa ppa:neovim-ppa/stable
apt_packages+=(neovim)

# https://github.com/rbenv/ruby-build/wiki
apt_packages+=(
  autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev
  libncurses5-dev libffi-dev libgdbm3 libgdbm-dev zlib1g-dev
)

# Add APT sources.
function __temp() { [[ ! -e /etc/apt/sources.list.d/$1.list ]]; }
source_i=($(array_filter_i apt_source_files __temp))

if (( ${#source_i[@]} > 0 )); then
  e_header "Adding APT sources (${#source_i[@]})"
  for i in "${source_i[@]}"; do
    source_file=${apt_source_files[i]}
    source_text=${apt_source_texts[i]}
    if [[ "$source_text" =~ ppa: ]]; then
      e_info "$source_text"
      sudo add-apt-repository -y $source_text
    else
      e_info "$source_file"
      sudo sh -c "echo '$source_text' > /etc/apt/sources.list.d/$source_file.list"
    fi
  done
fi

# Update APT.
e_info "Updating APT"
sudo apt-get update

e_info "Upgrading APT"
sudo apt-get upgrade

# Install APT packages.
installed_apt_packages="$(dpkg --get-selections | grep -v deinstall | awk 'BEGIN{FS="[\t:]"}{print $1}' | uniq)"
apt_packages=($(setdiff "${apt_packages[*]}" "$installed_apt_packages"))

if (( ${#apt_packages[@]} > 0 )); then
  e_info "Installing APT packages (${#apt_packages[@]})"
  for package in "${apt_packages[@]}"; do
    e_info "$package"
    [[ "$(type -t preinstall_$package)" == function ]] && preinstall_$package
    sudo apt-get -qq install "$package" && \
    [[ "$(type -t postinstall_$package)" == function ]] && postinstall_$package
  done
fi

e_info "Run APT autoclean"
sudo apt-get autoclean

e_info "Run APT autoremove"
sudo apt-get autoremove
