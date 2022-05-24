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

##### Zstd m32
unset {C,CPP,CXX,LD}FLAGS
CFLAGS="${FLAGSi686}"
CXXFLAGS="${FLAGSi686}"
LDFLAGS="${FLAGSi686}"

make clean
CC="gcc -m32" make -j$cpu
make prefix=/usr DESTDIR=$PWD/DESTDIR install
cp -Rv DESTDIR/usr/lib/* /usr/lib32/
sed -e "/^libdir/s/lib$/lib32/" -i /usr/lib32/pkgconfig/libzstd.pc
rm -rf DESTDIR
