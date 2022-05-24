#!/bin/sh
source ../env.sh

name=gperf
version=3.1

cd /sources/src
rm -rf ${name}-${version}
tar -xf ${name}-${version}.tar.gz
cd ${name}-${version}

./configure --prefix=/usr --docdir=/usr/share/doc/${name}-${version}
make -j$cpu
make install
