#!/bin/sh
source ../env.sh
source ../function.sh

name=zlib
version=1.2.12

cd /sources/src
rm -rf ${name}-${version}
tar -xf ${name}-${version}.tar.xz
cd ${name}-${version}

##### zlib
add_ffat_lto

patch -Np1 -i ../zlib-1.2.12-fix-CC-logic-in-configure.patch

./configure --prefix=/usr

make -j$cpu
make  install
rm -fv /usr/lib/libz.a

##### zlib m32
unset {C,CPP,CXX,LD}FLAGS
CFLAGS="${FLAGSi686}"
CXXFLAGS="${FLAGSi686}"
LDFLAGS="${FLAGSi686}"

make distclean
CC="gcc -m32" \
./configure --prefix=/usr \
    --libdir=/usr/lib32
make -j$cpu
make DESTDIR=$PWD/DESTDIR install
cp -Rv DESTDIR/usr/lib32/* /usr/lib32
rm -rf DESTDIR
