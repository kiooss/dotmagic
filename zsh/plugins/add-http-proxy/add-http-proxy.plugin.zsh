
add-http-proxy-command-line() {
    [[ -z $BUFFER ]] && zle up-history
    if [[ $BUFFER == http_proxy=*\ * ]]; then
        LBUFFER="${LBUFFER#env ALL_PROXY=socks5h://${MY_PROXY_HOST:-localhost}:7891 }"
    else
        LBUFFER="env ALL_PROXY=socks5h://${MY_PROXY_HOST:-localhost}:7891 https_proxy=http://${MY_PROXY_HOST:-localhost}:7890 http_proxy=http://${MY_PROXY_HOST:-localhost}:7890 $LBUFFER"
    fi
}
zle -N add-http-proxy-command-line
# Defined shortcut keys:
bindkey "\ep" add-http-proxy-command-line
