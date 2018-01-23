
#// vim: set ft=zsh:

function make-writeable {
    echo $*
    APACHEUSER=`ps aux | grep -E '[a]pache|[h]ttpd|[_]www|[w]ww-data' | grep -v root | head -1 | cut -d\  -f1`
    sudo setfacl -R -m u:"$APACHEUSER":rwX -m u:`whoami`:rwX $*
    sudo setfacl -dR -m u:"$APACHEUSER":rwX -m u:`whoami`:rwX $*
}

function restart-ssh-agent {
    set -x
    killall ssh-agent
    eval `ssh-agent`
    SSHIDFILE="$HOME/.ssh/id_sec_key_svn"
    if [[ -f "$SSHIDFILE" ]]; then
        ssh-add "$SSHIDFILE"
    fi
}

function show-user-list {
    cat /etc/passwd | cut -d ":" -f1
}

function find-large-dirs {
    local -A opthash
    zparseopts -D -A opthash -- -maxdepth: -tailsize:
    local maxdepth=1
    local tailsize=20

    if [[ -n "${opthash[(i)--maxdepth]}" ]]; then
        maxdepth=${opthash[--maxdepth]}
    fi

    if [[ -n "${opthash[(i)--tailsize]}" ]]; then
        tailsize=${opthash[--tailsize]}
    fi

    if [[ $# -eq 0 ]] ; then
        echo "Usage: $0 [dir]";
        return 1
    fi

    set -x
    find $1 -maxdepth $maxdepth -type d -print0 | xargs -0 du | sort -n | tail -n $tailsize | cut -f2 | xargs -I{} du -sh {}
}

function dummy-function-with-option() {
    local -A opthash
    zparseopts -D -A opthash -- -help -version v S:

    if [[ -n "${opthash[(i)--help]}" ]]; then
        # --helpが指定された場合
        echo "--help option"
    fi

    if [[ -n "${opthash[(i)--version]}" ]]; then
        # --versionが指定された場合
        echo "--version option"
    fi

    if [[ -n "${opthash[(i)-v]}" ]]; then
        # -vが指定された場合
        echo "-v option"
    fi

    if [[ -n "${opthash[(i)-S]}" ]]; then
        # -Sが指定された場合
        echo "-s option : ${opthash[-S]}"
    fi

    echo "normal arguments : $@"
}

function git-change-user-email {
    git filter-branch --commit-filter '
      if [ "$GIT_AUTHOR_EMAIL" = "wrong_email@wrong_host.local" ];
      then
              GIT_AUTHOR_NAME="Your Name Here (In Lights)";
              GIT_AUTHOR_EMAIL="correct_email@correct_host.com";
              git commit-tree "$@";
      else
              git commit-tree "$@";
      fi' HEAD
}

# Generate an SSL key and a signing request or self-signed certificate
function sslcert() {
    cn=$1

    # The prefix for the certificate's subject, eg
    # SUBJ="/C=GB/ST=Edinburgh/L=Edinburgh/O=Widget Co"
    SUBJ="/C=JP/ST=Tokyo/L=Tokyo/O=Webimpact Co"

    if [ -z "$cn" -o "$cn" = "-h" ]; then
        echo "usage: $0 <common name> [csr|crt]" >&2
        echo "  csr - generate a certificate signing request (default)" >&2
        echo "  crt - generate a self-signed certificate" >&2
        return 1
    fi

    type=${2:-csr}

    name=$(echo $cn | sed -e 's/^\*\./star./')
    if [ -r $name ]; then
        echo "$0: $name already exists"
        return 1
    fi
    mkdir $name
    if [ $? -ne 0 ]; then
        echo "$0: can't mkdir $name" >&2
        return 1
    fi
    cd $name
    openssl genrsa -out ${name}.key 4096
    case $type in
    csr)
        openssl req -new -key ${name}.key -out ${name}.csr -sha256 -subj "${SUBJ}/CN={cn}"
        ;;
    crt)
        openssl req -new -x509 -days 3650 -key ${name}.key -out ${name}.crt -sha256 -subj "${SUBJ}/CN=${cn}"
        ;;
    esac
    cd ..
}

function apache_ssl_config_template() {
cat << EOF
SSLEngine on
SSLCertificateFile /usr/local/apache/conf/ssl.crt/server.crt
SSLCertificateKeyFile /usr/local/apache/conf/ssl.key/server.key
SetEnvIf User-Agent ".*MSIE.*" nokeepalive ssl-unclean-shutdown
CustomLog logs/ssl_request_log \
   "%t %h %{SSL_PROTOCOL}x %{SSL_CIPHER}x \"%r\" %b"
EOF
}

function scan_port() {
    set -x
    sudo nmap -p $2 -sV $1
}

function chmod-r() {
    if [[ $# -eq 0 ]] ; then
        echo "Usage: $0 [dir] [type:f or d] [mod]";
        echo "Example: $0 . d 755"
        echo "Example: $0 . f 644"
        return 1
    fi
    set -x
    find $1 -type $2 -exec chmod $3 {} +
}

function text-replace() {
    if [[ $# -eq 0 ]] ; then
        echo "Usage: $0 [from] [to] [dir]";
        echo "Example: $0 foo bar /tmp"
        return 1
    fi
    set -x
    grep -rl $1 $3 | xargs sed -i -e "s/$1/$2/g"
}

function indent-with-vim() {
    set -x
    #vim -E -c "normal ggVG=" $1 <<'EOF'
    vim -E -s -u $HOME/.vimrc -c "normal gg=G" $1 <<'EOF'
:wq
EOF
}

function installed-packages() {
    dpkg --get-selections
}

function quick-download() {
    if [[ $# -eq 0 ]] ; then
        echo "Usage: $0 [url]";
        return 1
    fi
    aria2c --file-allocation=none -c -x 10 -s 10 -d ~/Downloads $1
}

function git-pack-changed-files()
{
    if [[ $# -eq 0 ]] ; then
        echo "Usage: $0 [filename] [commit]";
        return 1
    fi
    set -x
    git archive -o $1 HEAD $(git diff --name-only $2)
}

function git-pack-changed-files-encrypt()
{
    if [[ $# -eq 0 ]] ; then
        echo "Usage: $0 [filename] [commit]";
        return 1
    fi
    set -x
    zip --encrypt $1 $(git diff --name-only $2)
}

function reload-fixture()
{
    sf doctrine:fixtures:load --no-interaction && \
    sf hautelook_alice:doctrine:fixtures:load --append --no-interaction
}

function make-tags()
{
    if [[ -f $(find . -maxdepth 2 -mindepth 1 -name 'console' -type f) ]]; then
        echo 'make php tags'
        make-tags-php
    elif [[ -f $(find . -maxdepth 2 -mindepth 1 -name 'application.rb' -type f) ]]; then
        echo 'make ruby tags'
        make-ruby-tags
    else
        echo 'Not a Symfony nor Rails project.'
    fi
}

function make-tags-php()
{
    exctags -R \
        --exclude=".svn" \
        --exclude=".git" \
        --exclude=".rsync_cache" \
        --exclude="cache" \
        --exclude="*.phar" \
        --exclude="autocomplete.php" \
        --exclude="Tests" \
        --exclude="tests" \
        --exclude="Test" \
        --exclude="test" \
        --exclude="tmp" \
        --fields=+aimlS \
        --languages=php \
        --php-kinds=-av
}

function make-tags-ruby()
{
    exctags -R \
        --exclude=".svn" \
        --exclude=".git" \
        --exclude=".rsync_cache" \
        --exclude="log" \
        --exclude="tmp" \
        --regex-ruby='/^[ \t ]*scope[ \t ]*:([a-zA-Z0-9_]+)/\1/' \
        --languages=ruby * $(bundle list --paths)
}

function find-f()
{
    find . -type f -name "*$1*"
}

function show-256-colors()
{
    for i in {0..255}; do echo -e "\e[38;05;${i}m${i}"; done | column -c 280 -s ' '; echo -e "\e[m"
}

function get-my-ip()
{
    dig +short myip.opendns.com @208.67.222.222
}

function ssh() {
    if [ "$(ps -p $(ps -p $$ -o ppid=) -o comm=)" = "tmux: server" ]; then
        # tmux rename-window "$(echo $* | rev | cut -d ' ' -f1 | rev | cut -d . -f 1)"
        local window_name=$(tmux display -p '#{window_name}')
        tmux rename-window "💻 $(echo $*)"
        command ssh "$@"
        tmux rename-window $window_name
        # tmux set-window-option automatic-rename "on" 1>/dev/null
    else
        command ssh "$@"
    fi
}

function get-php-download-url() {
    echo "https://github.com/php/php-src/archive/php-$1.tar.gz"
}

function initeditorconfig() {
    if [ -e '.editorconfig' ]; then
        echo "[ERROR] .editorconfig already exists!"
    else
        cat $DOTFILES/templates/editorconfig > .editorconfig
        echo "[OK] .editorconfig created!"
    fi
}
