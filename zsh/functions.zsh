#// vim: set ft=zsh:

function make-writeable {
    echo $*
    APACHEUSER=`ps aux | grep -E '[a]pache|[h]ttpd|[_]www|[w]ww-data' | grep -v root | head -1 | cut -d\  -f1`
    sudo setfacl -R -m u:"$APACHEUSER":rwX -m u:`whoami`:rwX $*
    sudo setfacl -dR -m u:"$APACHEUSER":rwX -m u:`whoami`:rwX $*
}

function restart-ssh-agent {
    killall ssh-agent; eval `ssh-agent`
}

function show_user_list {
    cat /etc/passwd | cut -d ":" -f1
}

function flush_dns() {
    echo 'Flush dns'
    if [ "$(uname)" == "Darwin" ]; then
        sudo killall -HUP mDNSResponder
    else
        echo "Do nothing."
    fi
}
