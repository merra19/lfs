#!/bin/sh
source ../env.sh

name=expat
version=2.4.8

cd /sources/src
rm -rf ${name}-${version}
tar -xf ${name}-${version}.tar.xz
cd ${name}-${version}

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/${name}-${version}
make -j$cpu
make install
install -v -m644 doc/*.{html,css} /usr/share/doc/${name}-${version}

##### expat m32
unset {C,CPP,CXX,LD}FLAGS
CFLAGS="${FLAGSi686}"
CXXFLAGS="${FLAGSi686}"
LDFLAGS="${FLAGSi686}"

sed -e "/^am__append_1/ s/doc//" -i Makefile
make clean

CC="gcc -m32" CXX="g++ -m32" ./configure \
    --prefix=/usr         \
    --libdir=/usr/lib32  \
    --host=i686-pc-linux-gnu
make -j$cpu
make DESTDIR=$PWD/DESTDIR install
cp -Rv DESTDIR/usr/lib32/* /usr/lib32
rm -rf DESTDIR
