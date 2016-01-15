#!/bin/bash

# usage - ./build_php.sh php-5.5.0
# where php-5.5.0 is a PHP source directory

# current directory
DIR="$( cd "$( dirname "$0" )" && pwd )"

# requires a php source directory as a first argument
if [ ! -d "$1" ]
then
    echo "Php source is not a valid directory"
    exit 1
fi

# Ubuntu users only, a quirk to locate libpcre
if [ ! -f "/usr/lib/libpcre.a" ]; then
    if [ -f "/usr/lib/i386-linux-gnu/libpcre.a" ]; then
        sudo ln -s /usr/lib/i386-linux-gnu/libpcre.a /usr/lib/libpcre.a
    elif [ -f "/usr/lib/x86_64-linux-gnu/libpcre.a" ]; then
        sudo ln -s /usr/lib/x86_64-linux-gnu/libpcre.a /usr/lib/libpcre.a
    fi
fi

# define full path to php sources
SRC="$DIR/$1"

# Here follows paths for installation binaries and general settings
PREFIX="$HOME/php" # will install binaries in ~/php/bin directory, make sure it is exported in your $PATH for executables
SBIN_DIR="$HOME/php" # all binaries will go to ~/php/bin
CONF_DIR="$HOME/php" # will use php.ini located here as ~/php/php.ini
CONFD_DIR="$HOME/php/conf.d" # will load all extra configuration files from ~/php/conf.d directory
MAN_DIR="$HOME/php/share/man" # man pages goes here

EXTENSION_DIR="$HOME/php/share/modules" # all shared modules will be installed in ~/php/share/modules phpize binary will configure it accordingly
export EXTENSION_DIR
PEAR_INSTALLDIR="$HOME/php/share/pear" # pear package directory
export PEAR_INSTALLDIR

if [ ! -d "$CONFD_DIR" ]; then
    mkdir -p $CONFD_DIR
fi

# here follows a main configuration script
PHP_CONF="--config-cache \
    --prefix=$PREFIX \
    --sbindir=$SBIN_DIR \
    --sysconfdir=$CONF_DIR \
    --localstatedir=/var \
    --with-layout=GNU \
    --with-config-file-path=$CONF_DIR \
    --with-config-file-scan-dir=$CONFD_DIR \
    --disable-rpath \
    --mandir=$MAN_DIR \
"

# enter source directory
cd $SRC

# build configure, not included in git versions
if [ ! -f "$SRC/configure" ]; then
    ./buildconf --force
fi

# Additionally you can add these, if they are needed:
#   --enable-ftp
#   --enable-exif
#   --enable-calendar
#   --with-snmp=/usr
#   --with-pspell
#   --with-tidy=/usr
#   --with-xmlrpc
#   --with-xsl=/usr
# and any other, run "./configure --help" inside php sources

# define extension configuration
EXT_CONF="--enable-mbstring \
    --enable-mbregex \
    --enable-phar \
    --enable-posix \
    --enable-soap \
    --enable-sockets \
    --enable-sysvmsg \
    --enable-sysvsem \
    --enable-sysvshm \
    --enable-zip \
    --enable-inline-optimization \
    --enable-intl \
    --with-icu-dir=/usr \
    --with-curl=/usr/bin \
    --with-gd \
    --with-jpeg-dir=/usr \
    --with-png-dir=shared,/usr \
    --with-xpm-dir=/usr \
    --with-freetype-dir=/usr \
    --with-bz2=/usr \
    --with-gettext \
    --with-iconv-dir=/usr \
    --with-mcrypt=/usr \
    --with-mhash \
    --with-zlib-dir=/usr \
    --with-regex=php \
    --with-pcre-regex=/usr \
    --with-openssl \
    --with-openssl-dir=/usr/bin \
    --with-mysql-sock=/var/run/mysqld/mysqld.sock \
    --with-mysqli=mysqlnd \
    --with-sqlite3=/usr \
    --with-pdo-mysql=mysqlnd \
    --with-pdo-sqlite=/usr
"

# adapt fpm user and group if different wanted
PHP_FPM_CONF="--enable-fpm \
    --with-fpm-user=www-data \
    --with-fpm-group=www-data
"

# CLI, php-fpm and apache2 module
./configure $PHP_CONF \
    --disable-cgi \
    --with-readline \
    --enable-pcntl \
    --enable-cli \
    --with-apxs2=/usr/bin/apxs2 \
    --with-pear \
    $PHP_FPM_CONF \
    $EXT_CONF

# CGI and FastCGI
#./configure $PHP_CONF --disable-cli --enable-cgi $EXT_CONF

# build sources
make

