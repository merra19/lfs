#!/bin/sh
source ../env.sh

name=flex
version=2.6.4

cd /sources/src
rm -rf ${name}-${version}
tar -xf ${name}-${version}.tar.gz
cd ${name}-${version}

./configure --prefix=/usr \
            --docdir=/usr/share/doc/${name}-${version} \
            --disable-static

make -j$cpu
make install
ln -sfv flex /usr/bin/lex
