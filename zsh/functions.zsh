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


function update_dotfiles() {
    echo "Updating dotfiles."
    echo $DOTFILES
    cd "$DOTFILES"
    if git pull --rebase --stat origin master
    then
        echo "Dotfiles has been updated."
    else
        echo "Failed!"
    fi
    cd -
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
        --php-kinds=-a
}
