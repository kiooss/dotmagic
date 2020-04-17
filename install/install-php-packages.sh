#!/usr/bin/env zsh

source "$(dirname "$0")/util.sh"

e_header "Global php packages"

composer global require hirak/prestissimo
composer global require friendsofphp/php-cs-fixer
