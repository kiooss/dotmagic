function flush_dns() {
    echo 'Flush dns'
    if [ "$(uname)" == "Darwin" ]; then
        sudo killall -HUP mDNSResponder
    else
        echo "Do nothing."
    fi
}

# turn hidden files on/off in Finder
function hiddenOn() { defaults write com.apple.Finder AppleShowAllFiles YES ; }
function hiddenOff() { defaults write com.apple.Finder AppleShowAllFiles NO ; }

# view man pages in Preview
function pman() { ps=`mktemp -t manpageXXXX`.ps ; man -t $@ > "$ps" ; open "$ps" ; }
