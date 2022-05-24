#!/bin/sh
source ../env.sh

name=popt
version=1.18

cd /sources/src
rm -rf ${name}-${version}
tar -xf ${name}-${version}.tar.gz
cd ${name}-${version}

./configure --prefix=/usr --disable-static &&
make -j$cpu
make install
