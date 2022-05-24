#!/bin/sh
source ../env.sh

name=libpipeline
version=1.5.6

cd /sources/src
rm -rf ${name}-${version}
tar -xf ${name}-${version}.tar.gz
cd ${name}-${version}

./configure --prefix=/usr
make -j$cpu
make install
