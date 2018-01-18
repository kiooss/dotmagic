R_CURRENT_BG='NONE'

() {
  local LC_ALL="" LC_CTYPE="en_US.UTF-8"
  R_SEGMENT_SEPARATOR=$'\ue0b2'
}

rprompt_segment() {
  local bg fg
  [[ -n $1 ]] && bg=$1
  [[ -n $2 ]] && fg=$2
  if [[ $R_CURRENT_BG != 'NONE' && $1 != $R_CURRENT_BG ]]; then
    echo -n "%{%F{$bg}%}%{%K{$R_CURRENT_BG}%}$R_SEGMENT_SEPARATOR%{%K{$bg}%}%{%F{$fg}%}"
  else
    echo -n "%{%F{$bg}%}%{%k%}$R_SEGMENT_SEPARATOR%{%K{$bg}%}%{%F{$fg}%}"
  fi
  R_CURRENT_BG=$1
  [[ -n $3 ]] && echo -n $3
}

build_rprompt() {
  RETVAL=$?
  rprompt_segment blue black "$(drink_water)"
  rprompt_segment red black '  Happy Coding!'
}

RPROMPT='%{%f%b%k%}$(build_rprompt)'
