#!/bin/sh
source ../env.sh

name=make
version=4.3

cd $LFS/sources/src
rm -rf ${name}-${version}
tar -xf ${name}-${version}.tar.gz
cd ${name}-${version}

./configure --prefix=/usr   \
            --without-guile \
            --host=$LFS_TGT \
            --build=$(build-aux/config.guess)

make -j$cpu
make DESTDIR=$LFS install
