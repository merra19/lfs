#!/bin/sh
source ../env.sh
source ../function.sh

name=acl
version=2.3.1

cd /sources/src
rm -rf ${name}-${version}
tar -xf ${name}-${version}.tar.xz
cd ${name}-${version}

####  remove lto
rm_lto

./configure --prefix=/usr         \
            --disable-static      \
            --docdir=/usr/share/doc/${name}-${version}

make -j$cpu
make check
