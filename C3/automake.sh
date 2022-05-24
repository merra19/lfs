#!/bin/sh
source ../env.sh

name=automake
version=1.16.5

cd /sources/src
rm -rf ${name}-${version}
tar -xf ${name}-${version}.tar.xz
cd ${name}-${version}

./configure --prefix=/usr --docdir=/usr/share/doc/${name}-${version}
make -j$cpu
make install
