#!/bin/sh
source ../env.sh
source ../function.sh

name=m4
version=1.4.19

cd /sources/src
rm -rf ${name}-${version}
tar -xf ${name}-${version}.tar.xz
cd ${name}-${version}

add_ffat_lto

./configure --prefix=/usr
make -j$cpu
make install
