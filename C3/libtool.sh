#!/bin/sh
source ../env.sh

name=libtool
version=2.4.7

cd /sources/src
rm -rf ${name}-${version}
tar -xf ${name}-${version}.tar.xz
cd ${name}-${version}

./configure --prefix=/usr
make -j$cpu
make install
rm -fv /usr/lib/libltdl.a

##### libtool m32
unset {C,CPP,CXX,LD}FLAGS
CFLAGS="${FLAGSi686}"
CXXFLAGS="${FLAGSi686}"
LDFLAGS="${FLAGSi686}"

make distclean
CC="gcc -m32" ./configure \
    --host=i686-pc-linux-gnu \
    --prefix=/usr            \
    --libdir=/usr/lib32
make -j$cpu
make DESTDIR=$PWD/DESTDIR install
cp -Rv DESTDIR/usr/lib32/* /usr/lib32
rm -rf DESTDIR
