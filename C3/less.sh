#!/bin/sh
source ../env.sh

name=less
version=590

cd /sources/src
rm -rf ${name}-${version}
tar -xf ${name}-${version}.tar.gz
cd ${name}-${version}

./configure --prefix=/usr --sysconfdir=/etc
make -j$cpu
make install
