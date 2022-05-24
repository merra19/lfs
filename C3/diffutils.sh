#!/bin/sh
source ../env.sh

name=diffutils
version=3.8

cd /sources/src
rm -rf ${name}-${version}
tar -xf ${name}-${version}.tar.xz
cd ${name}-${version}

./configure --prefix=/usr
make -j$cpu
make install
