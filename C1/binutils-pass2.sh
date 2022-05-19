#!/bin/sh
source ../env.sh

name=binutils
version=2.38

cd $LFS/sources/src
rm -rf ${name}-${version}
tar -xf ${name}-${version}.tar.xz
cd ${name}-${version}

unset {C,CPP,CXX,LD}FLAGS

sed '6009s/$add_dir//' -i ltmain.sh

mkdir -v build
cd       build

../configure                   \
    --prefix=/usr              \
    --build=$(../config.guess) \
    --host=$LFS_TGT            \
    --disable-nls              \
    --enable-shared            \
    --disable-werror           \
    --enable-64-bit-bfd        \
    --enable-multilib

make -j$cpu
make DESTDIR=$LFS install -j1
