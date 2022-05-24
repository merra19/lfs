#!/bin/sh
source ../env.sh

name=pkg-config
version=0.29.2

cd /sources/src
rm -rf ${name}-${version}
tar -xf ${name}-${version}.tar.gz
cd ${name}-${version}

./configure --prefix=/usr              \
            --with-internal-glib       \
            --disable-host-tool        \
            --docdir=/usr/share/doc/${name}-${version}

make -j$cpu
make install
