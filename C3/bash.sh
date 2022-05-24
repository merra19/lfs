#!/bin/sh
source ../env.sh

name=bash
version=5.1.16

cd /sources/src
rm -rf ${name}-${version}
tar -xf ${name}-${version}.tar.gz
cd ${name}-${version}


./configure --prefix=/usr                      \
            --docdir=/usr/share/doc/${name}-${version} \
            --without-bash-malloc              \
            --with-installed-readline

make  -j$cpu
make install

#exec /usr/bin/bash --login
