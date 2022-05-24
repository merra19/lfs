#!/bin/sh
source ../env.sh
source ../function.sh

name=bc
version=5.2.5

cd /sources/src
rm -rf ${name}-${version}
tar -xf ${name}-${version}.tar.xz
cd ${name}-${version}

rm_O2

CC=gcc ./configure --prefix=/usr -G -O3
make -j$cpu
make install
