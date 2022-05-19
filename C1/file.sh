#!/bin/sh
source ../env.sh

name=file
version=5.41

cd $LFS/sources/src
rm -rf ${name}-${version}
tar -xf ${name}-${version}.tar.gz
cd ${name}-${version}

mkdir build
pushd build
 ../configure --disable-bzlib      \
               --disable-libseccomp \
               --disable-xzlib      \
               --disable-zlib
  make
popd

./configure --prefix=/usr --host=$LFS_TGT --build=$(./config.guess)

make -j$cpu FILE_COMPILE=$(pwd)/build/src/file
make DESTDIR=$LFS install
