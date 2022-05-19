#!/bin/sh
source ../env.sh

name=gcc
version=12.1.0

cd $LFS/sources/src
rm -rf ${name}-${version}
tar -xf ${name}-${version}.tar.xz
cd ${name}-${version}

unset {C,CPP,CXX,LD}FLAGS

mkdir -v build
cd       build


../libstdc++-v3/configure           \
    --host=$LFS_TGT                 \
    --build=$(../config.guess)      \
    --prefix=/usr                   \
    --enable-multilib              \
    --disable-nls                   \
    --disable-libstdcxx-pch         \
    --with-gxx-include-dir=/tools/$LFS_TGT/include/c++/${version}

make -j$cpu
make DESTDIR=$LFS install
