#!/bin/sh
source ../env.sh

name=expect
version=5.45.4

cd /sources/src
rm -rf ${name}${version}
tar -xf ${name}${version}.tar.gz
cd ${name}${version}

./configure --prefix=/usr           \
            --with-tcl=/usr/lib     \
            --enable-shared         \
            --mandir=/usr/share/man \
            --with-tclinclude=/usr/include

make -j$cpu
make install
ln -svf ${name}${version}/${name}${version}.so /usr/lib
