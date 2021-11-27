function flush_dns() {
    echo 'Flush dns'
    if [ "$(uname)" = "Darwin" ]; then
        sudo killall -HUP mDNSResponder;sudo killall mDNSResponderHelper;sudo dscacheutil -flushcache;
        echo "MacOS DNS cache has been cleared."
    else
        echo "Do nothing."
    fi
}

# turn hidden files on/off in Finder
function hiddenOn() { defaults write com.apple.Finder AppleShowAllFiles YES ; }
function hiddenOff() { defaults write com.apple.Finder AppleShowAllFiles NO ; }

# view man pages in Preview
function pman() { ps=`mktemp -t manpageXXXX`.ps ; man -t $@ > "$ps" ; open "$ps" ; }

function find-printer-ip() {
    ping 192.168.1.255 && arp -a | grep '0:15:99:db:85:84'
}

function show-listen-ports() {
    sudo lsof -iTCP -sTCP:LISTEN -n -P
}

function show-established-tcp-connections() {
    sudo lsof -iTCP -sTCP:ESTABLISHED -n -P
}

function network-restart() {
    sudo ifconfig en0 down && sudo ifconfig en0 up
}

function change-screencapture-location() {
    defaults write com.apple.screencapture location $1
    killall SystemUIServer
}

function change-screencapture-name() {
    defaults write com.apple.screencapture name $1
    killall SystemUIServer
}
