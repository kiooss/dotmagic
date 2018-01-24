#!/bin/bash

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
