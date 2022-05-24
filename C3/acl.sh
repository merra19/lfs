#!/bin/sh
source ../env.sh
source ../function.sh

name=acl
version=2.3.1

cd /sources/src
rm -rf ${name}-${version}
tar -xf ${name}-${version}.tar.xz
cd ${name}-${version}

####  remove lto
rm_lto

./configure --prefix=/usr         \
            --disable-static      \
            --docdir=/usr/share/doc/${name}-${version}

make -j$cpu
make install

##### acl m32
unset {C,CPP,CXX,LD}FLAGS
CFLAGS="${FLAGSi686}"
CXXFLAGS="${FLAGSi686}"
LDFLAGS="${FLAGSi686}"

make distclean
CC="gcc -m32" ./configure \
    --prefix=/usr         \
    --disable-static      \
    --libdir=/usr/lib32   \
    --libexecdir=/usr/lib32   \
    --host=i686-pc-linux-gnu
make -j$cpu
make DESTDIR=$PWD/DESTDIR install
cp -Rv DESTDIR/usr/lib32/* /usr/lib32
rm -rf DESTDIR
