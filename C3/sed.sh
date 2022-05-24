#!/bin/sh
source ../env.sh

name=sed
version=4.8

cd /sources/src
rm -rf ${name}-${version}
tar -xf ${name}-${version}.tar.xz
cd ${name}-${version}

./configure --prefix=/usr

make -j$cpu
make html -j$cpu
make install
install -d -m755           /usr/share/doc/${name}-${version}
install -m644 doc/sed.html /usr/share/doc/${name}-${version}
