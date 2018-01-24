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

e_header() {
  printf "\n${BLUE}★★★★★${NORMAL} ${CYAN}$@${NORMAL} ${BLUE}♪${NORMAL}\n"
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

# OS detection
function is_osx() {
  [[ "$OSTYPE" =~ ^darwin ]] || return 1
}

function is_ubuntu() {
  [[ "$(cat /etc/issue 2> /dev/null)" =~ Ubuntu ]] || return 1
}

# Given strings containing space-delimited words A and B, "setdiff A B" will
# return all words in A that do not exist in B. Arrays in bash are insane
# (and not in a good way).
# From http://stackoverflow.com/a/1617303/142339
function setdiff() {
  local debug skip a b
  if [[ "$1" == 1 ]]; then debug=1; shift; fi
  if [[ "$1" ]]; then
    local setdiff_new setdiff_cur setdiff_out
    setdiff_new=($1); setdiff_cur=($2)
  fi
  setdiff_out=()
  for a in "${setdiff_new[@]}"; do
    skip=
    for b in "${setdiff_cur[@]}"; do
      [[ "$a" == "$b" ]] && skip=1 && break
    done
    [[ "$skip" ]] || setdiff_out=("${setdiff_out[@]}" "$a")
  done
  [[ "$debug" ]] && for a in setdiff_new setdiff_cur setdiff_out; do
    echo "$a ($(eval echo "\${#$a[*]}")) $(eval echo "\${$a[*]}")" 1>&2
  done
  [[ "$1" ]] && echo "${setdiff_out[@]}"
}

function version_gt() { test "$(printf '%s\n' "$@" | sort -V | head -n 1)" != "$1"; }
