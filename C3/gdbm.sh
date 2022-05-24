#!/bin/sh
source ../env.sh

name=gdbm
version=1.23

cd /sources/src
rm -rf ${name}-${version}
tar -xf ${name}-${version}.tar.gz
cd ${name}-${version}

./configure --prefix=/usr    \
            --disable-static \
            --enable-libgdbm-compat

make -j$cpu
make install
