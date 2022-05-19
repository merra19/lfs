#!/bin/sh
source ../env.sh

name=Python
version=3.10.4

cd /sources/src
rm -rf ${name}-${version}
tar -xf ${name}-${version}.tar.xz
cd ${name}-${version}

./configure --prefix=/usr   \
            --enable-shared \
            --without-ensurepip

make -j$cpu
make install
