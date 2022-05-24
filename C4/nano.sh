#!/bin/sh
source ../env.sh

name=nano
version=6.3

cd /sources/src
rm -rf ${name}-${version}
tar -xf ${name}-${version}.tar.xz
cd ${name}-${version}

./configure --prefix=/usr     \
            --sysconfdir=/etc \
            --enable-utf8     \
            --docdir=/usr/share/doc/nano-$version

make
make install

install -v -Dm644 doc/sample.nanorc /etc/nanorc

cat > /etc/nanorc << "EOF"
set autoindent
set constantshow
set fill 72
set historylog
set multibuffer
set nohelp
set positionlog
set quickblank
set regexp
set suspend
EOF

find /usr/share/nano/ -iname "*.nanorc" -exec echo include {} \; >> /etc/nanorc

