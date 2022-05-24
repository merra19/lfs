#!/bin/sh
source ../env.sh

name=mpc
version=1.2.1

cd /sources/src
rm -rf ${name}-${version}
tar -xf ${name}-${version}.tar.gz
cd ${name}-${version}

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/${name}-${version}

make -j$cpu
make html -j$cpu
make install
make install-html
