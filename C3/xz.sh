#!/bin/sh
source ../env.sh

name=xz
version=5.2.5

cd /sources/src
rm -rf ${name}-${version}
tar -xf ${name}-${version}.tar.xz
cd ${name}-${version}

patch -Np1 -i ../xz-5.2.5-upstream_fix-1.patch

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/${name}-${version}

make -j$cpu
make install

##### Xz m32
unset {C,CPP,CXX,LD}FLAGS
CFLAGS="${FLAGSi686}"
CXXFLAGS="${FLAGSi686}"
LDFLAGS="${FLAGSi686}"

make distclean
CC="gcc -m32" ./configure \
    --host=i686-pc-linux-gnu      \
    --prefix=/usr                 \
    --libdir=/usr/lib32           \
    --disable-static

make -j$cpu
make DESTDIR=$PWD/DESTDIR install
cp -Rv DESTDIR/usr/lib32/* /usr/lib32
rm -rf DESTDIR
