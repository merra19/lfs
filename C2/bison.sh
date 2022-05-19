#!/bin/sh
source ../env.sh

name=bison
version=3.8.2

cd /sources/src
rm -rf ${name}-${version}
tar -xf ${name}-${version}.tar.xz
cd ${name}-${version}


./configure --prefix=/usr \
            --docdir=/usr/share/doc/${name}-${version}
make -j$cpu
make install
