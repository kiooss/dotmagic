
add-http-proxy-command-line() {
    [[ -z $BUFFER ]] && zle up-history
    if [[ $BUFFER == http_proxy=*\ * ]]; then
        LBUFFER="${LBUFFER#http_proxy=\"http://192.168.1.100:8123\" }"
    else
        LBUFFER="http_proxy=\"http://192.168.1.100:8123\" $LBUFFER"
    fi
}
zle -N add-http-proxy-command-line
# Defined shortcut keys:
bindkey "\ep" add-http-proxy-command-line
