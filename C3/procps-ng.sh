#!/bin/sh
source ../env.sh

name=procps-ng
version=4.0.0

cd /sources/src
rm -rf ${name}-${version}
tar -xf ${name}-${version}.tar.xz
cd ${name}-${version}

./configure --prefix=/usr                            \
            --docdir=/usr/share/doc/${name}-${version} \
            --disable-static                         \
            --disable-kill
make -j$cpu
make install
