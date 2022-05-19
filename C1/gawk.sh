#!/bin/sh
source ../env.sh

name=gawk
version=5.1.1

cd $LFS/sources/src
rm -rf ${name}-${version}
tar -xf ${name}-${version}.tar.xz
cd ${name}-${version}

sed -i 's/extras//' Makefile.in
./configure --prefix=/usr                   \
            --host=$LFS_TGT                 \
            --build=$(build-aux/config.guess)

make -j$cpu
make DESTDIR=$LFS install
