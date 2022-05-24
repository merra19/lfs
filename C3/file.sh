#!/bin/sh
source ../env.sh

name=file
version=5.41

cd /sources/src
rm -rf ${name}-${version}
tar -xf ${name}-${version}.tar.gz
cd ${name}-${version}

./configure --prefix=/usr
make -j$cpu
make install

##### file m32
unset {C,CPP,CXX,LD}FLAGS
CFLAGS="${FLAGSi686}"
CXXFLAGS="${FLAGSi686}"
LDFLAGS="${FLAGSi686}"

make distclean
CC="gcc -m32" ./configure \
    --prefix=/usr         \
    --libdir=/usr/lib32   \
    --host=i686-pc-linux-gnu
make -j$cpu
make DESTDIR=$PWD/DESTDIR install
cp -Rv DESTDIR/usr/lib32/* /usr/lib32
rm -rf DESTDIR
