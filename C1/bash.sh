#!/bin/sh
source ../env.sh

name=bash
version=5.1.16

cd $LFS/sources/src
rm -rf ${name}-${version}
tar -xf ${name}-${version}.tar.gz
cd ${name}-${version}

./configure --prefix=/usr                   \
            --build=$(support/config.guess) \
            --host=$LFS_TGT                 \
            --without-bash-malloc

make -j$cpu
make DESTDIR=$LFS install
ln -sv bash $LFS/bin/sh
