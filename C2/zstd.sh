#!/bin/sh
source ../env.sh

name=zstd
version=1.5.2

cd /sources/src
rm -rf ${name}-${version}
tar -xf ${name}-${version}.tar.gz
cd ${name}-${version}

patch -Np1 -i ../zstd-1.5.2-upstream_fixes-1.patch
make -j$cpu
make prefix=/usr install
rm -v /usr/lib/libzstd.a
