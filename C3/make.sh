#!/bin/sh
source ../env.sh

name=make
version=4.3

cd /sources/src
rm -rf ${name}-${version}
tar -xf ${name}-${version}.tar.gz
cd ${name}-${version}

./configure --prefix=/usr
make -j$cpu
make install
