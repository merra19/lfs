#!/bin/sh
source ../env.sh

name=m4
version=1.4.19

cd $LFS/sources/src
rm -rf ${name}-${version}
tar -xf ${name}-${version}.tar.xz
cd ${name}-${version}

./configure --prefix=/usr   \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess)

make -j$cpu
make DESTDIR=$LFS install
