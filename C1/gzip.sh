#!/bin/sh
source ../env.sh

name=gzip
version=1.12

cd $LFS/sources/src
rm -rf ${name}-${version}
tar -xf ${name}-${version}.tar.xz
cd ${name}-${version}

./configure --prefix=/usr --host=$LFS_TGT

make -j$cpu
make DESTDIR=$LFS install
