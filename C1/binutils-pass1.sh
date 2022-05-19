#!/bin/sh
source ../env.sh

name=binutils
version=2.38

cd $LFS/sources/src
rm -rf ${name}-${version}
tar -xf ${name}-${version}.tar.xz
cd ${name}-${version}

unset {C,CPP,CXX,LD}FLAGS

mkdir -v build
cd       build

../configure --prefix=$LFS/tools       \
             --with-sysroot=$LFS \
             --target=$LFS_TGT   \
             --disable-nls       \
             --disable-werror    \
             --enable-multilib

make -j$cpu
make install -j1
