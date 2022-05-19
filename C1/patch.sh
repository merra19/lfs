#!/bin/sh
source ../env.sh

name=patch
version=2.7.6

cd $LFS/sources/src
rm -rf ${name}-${version}
tar -xf ${name}-${version}.tar.xz
cd ${name}-${version}

./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess)

make -j$cpu
make DESTDIR=$LFS install
