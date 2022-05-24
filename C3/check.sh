#!/bin/sh
source ../env.sh

name=check
version=0.15.2

cd /sources/src
rm -rf ${name}-${version}
tar -xf ${name}-${version}.tar.gz
cd ${name}-${version}

./configure --prefix=/usr --disable-static
make -j$cpu
make docdir=/usr/share/doc/${name}-${version} install
