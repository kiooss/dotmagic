#!/bin/sh

rm -i ./src/auto/config.cache

./configure \
--prefix=/usr/local \
--with-features=huge \
--with-compiledby="YangYang" \
--enable-multibyte \
--enable-gui=gtk2 \
--enable-perlinterp=yes \
--enable-rubyinterp=yes \
--enable-python3interp=yes \
--enable-perlinterp=yes \
--enable-luainterp=yes \
--with-lua-prefix=/usr/local \
--enable-gpm \
--enable-cscope \
--enable-fontset \
--enable-terminal \
--enable-fail-if-missing

# --with-python-config-dir=/usr/lib/python3.5/config-3.5m-x86_64-linux-gnu \

# make VIMRUNTIMEDIR=/usr/local/share/vim/vim80

# sudo checkinstall
