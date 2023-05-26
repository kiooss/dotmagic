function proxy-on() {
  local HOST=${MY_PROXY_HOST:-localhost}
  export https_proxy=http://$HOST:7890 http_proxy=http://$HOST:7890 all_proxy=socks5://$HOST:7890
  echo "on" > ~/.cache/proxy_state
}

function proxy-off() {
  unset all_proxy https_proxy http_proxy
  echo "off" > ~/.cache/proxy_state
}

function proxy-toggle() {
  if [[ -z "$all_proxy" ]]; then
    proxy-on && echo "proxy on: $all_proxy"
  else
    proxy-off && echo "Proxy off"
  fi
}

function proxy-state() {
  if [[ -z "$all_proxy" ]]; then
    echo -n ""
  else
    echo -n "🚀"
  fi
}

if [[ -f ~/.cache/proxy_state && `cat ~/.cache/proxy_state` == 'on' ]]; then
  proxy-on
fi

# zle -N proxy-toggle
# Defined shortcut keys:
bindkey -s "\et" '^Uproxy-toggle^M'
