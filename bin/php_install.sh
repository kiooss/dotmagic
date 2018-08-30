#!/usr/bin/env bash

set -ex

PHP_TARGET_VERSION=7.1.21
PHP_INSTALL_PREFIX=$HOME/.phps
mkdir -p $HOME/source/php-$PHP_TARGET_VERSION
cd $HOME/source/php-$PHP_TARGET_VERSION
# curl -# -L http://downloads.php.net/stas/php-$PHP_TARGET_VERSION.tar.gz | tar -xz --strip 1
curl -# -L http://jp2.php.net/get/php-$PHP_TARGET_VERSION.tar.gz/from/this/mirror | tar -xz --strip 1

./configure \
  --prefix=$PHP_INSTALL_PREFIX/$PHP_TARGET_VERSION \
  --sysconfdir=$PHP_INSTALL_PREFIX/$PHP_TARGET_VERSION/etc \
  --with-config-file-path=$PHP_INSTALL_PREFIX/$PHP_TARGET_VERSION/etc \
  --with-config-file-scan-dir=$PHP_INSTALL_PREFIX/$PHP_TARGET_VERSION/etc/conf.d \
  --mandir=$PHP_INSTALL_PREFIX/$PHP_TARGET_VERSION/share/man \
  # --disable-debug \
  --disable-cgi \
  --with-pear \
  --enable-pcntl \
  --enable-cli \
  --with-readline \
  --with-apxs2=/usr/bin/apxs2 \
  --enable-fpm \
  --with-fpm-user=www-data \
  --with-fpm-group=www-data \
  --enable-mbstring \
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
  --enable-opcache \
  --enable-bcmath \
  --enable-exif \
  --enable-calendar \
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
  --with-mhash \
  --with-zlib-dir=/usr \
  --with-openssl \
  --with-openssl-dir=/usr/bin \
  --with-mysql-sock=/var/run/mysqld/mysqld.sock \
  --with-mysqli=mysqlnd \
  --with-sqlite3=/usr \
  --with-pdo-mysql=mysqlnd \
  --with-pdo-pgsql=/usr \
  --with-pdo-sqlite=/usr \
  --with-xsl \

