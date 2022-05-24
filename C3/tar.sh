#!/bin/sh
source ../env.sh

name=tar
version=1.34

cd /sources/src
rm -rf ${name}-${version}
tar -xf ${name}-${version}.tar.xz
cd ${name}-${version}

FORCE_UNSAFE_CONFIGURE=1  \
./configure --prefix=/usr
make -j$cpu
make install
make -C doc install-html docdir=/usr/share/doc/${name}-${version}
