#!/bin/sh
source ../env.sh

name=gettext
version=0.21

cd /sources/src
rm -rf ${name}-${version}
tar -xf ${name}-${version}.tar.xz
cd ${name}-${version}

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/${name}-${version}

make -j$cpu
make install
chmod -v 0755 /usr/lib/preloadable_libintl.so
