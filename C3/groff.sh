#!/bin/sh
source ../env.sh

name=groff
version=1.22.4

cd /sources/src
rm -rf ${name}-${version}
tar -xf ${name}-${version}.tar.gz
cd ${name}-${version}

PAGE=A4 ./configure --prefix=/usr
make -j1
make install
