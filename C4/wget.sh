#!/bin/sh
source ../env.sh

name=wget
version=1.21.3

cd /sources/src
rm -rf ${name}-${version}
tar -xf ${name}-${version}.tar.gz
cd ${name}-${version}

./configure --prefix=/usr      \
            --sysconfdir=/etc  \
            --with-ssl=openssl &&
make -j$cpu
make install
