#!/bin/sh
source ../env.sh

name=libcap
version=2.64

cd /sources/src
rm -rf ${name}-${version}
tar -xf ${name}-${version}.tar.xz
cd ${name}-${version}

#### Prevent static libraries from being installed
sed -i '/install -m.*STA/d' libcap/Makefile

make prefix=/usr lib=lib -j$cpu
make prefix=/usr lib=lib install

##### libcap m32
unset {C,CPP,CXX,LD}FLAGS
CFLAGS="${FLAGSi686}"
CXXFLAGS="${FLAGSi686}"
LDFLAGS="${FLAGSi686}"

cd /sources/src
rm -rf ${name}-${version}
tar -xf ${name}-${version}.tar.xz
cd ${name}-${version}

make CC="gcc -m32 -march=i686"
make CC="gcc -m32 -march=i686" lib=lib32 prefix=$PWD/DESTDIR/usr -C libcap install
cp -Rv DESTDIR/usr/lib32/* /usr/lib32
sed -e "s|^libdir=.*|libdir=/usr/lib32|" -i /usr/lib32/pkgconfig/lib{cap,psx}.pc
chmod -v 755 /usr/lib32/libcap.so.2.64
rm -rf DESTDIR
