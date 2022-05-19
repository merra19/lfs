#!/bin/sh
source ../env.sh

name=xz
version=5.2.5

cd $LFS/sources/src
rm -rf ${name}-${version}
tar -xf ${name}-${version}.tar.xz
cd ${name}-${version}

patch -Np1 -i ../xz-5.2.5-upstream_fix-1.patch

./configure --prefix=/usr                     \
            --host=$LFS_TGT                   \
            --build=$(build-aux/config.guess) \
            --disable-static                  \
            --docdir=/usr/share/doc/xz-5.2.5

make -j$cpu
make DESTDIR=$LFS install
