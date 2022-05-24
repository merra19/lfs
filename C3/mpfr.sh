#!/bin/sh
source ../env.sh

name=mpfr
version=4.1.0

cd /sources/src
rm -rf ${name}-${version}
tar -xf ${name}-${version}.tar.xz
cd ${name}-${version}

./configure --prefix=/usr        \
            --disable-static     \
            --enable-thread-safe \
            --docdir=/usr/share/doc/${name}-${version}

make -j$cpu
make html -j$cpu
make install
make install-html
