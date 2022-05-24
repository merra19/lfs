#!/bin/sh
source ../env.sh
source ../function.sh

name=elfutils
version=0.187

cd /sources/src
rm -rf ${name}-${version}
tar -xf ${name}-${version}.tar.bz2
cd ${name}-${version}

####  remove lto
add_ffat_lto

./configure --prefix=/usr                \
            --disable-debuginfod         \
            --enable-libdebuginfod=dummy
make -j$cpu
make install
make -C libelf install
install -vm644 config/libelf.pc /usr/lib/pkgconfig
rm /usr/lib/libelf.a

##### libelf m32
unset {C,CPP,CXX,LD}FLAGS
CFLAGS="${FLAGSi686}"
CXXFLAGS="${FLAGSi686}"
LDFLAGS="${FLAGSi686}"

make distclean

CC="gcc -m32" ./configure \
    --host=i686-pc-linux-gnu \
    --prefix=/usr            \
    --libdir=/usr/lib32      \
    --disable-debuginfod     \
    --enable-libdebuginfod=dummy
make -j$cpu
make DESTDIR=$PWD/DESTDIR install
make DESTDIR=$PWD/DESTDIR -C libelf install
install -vDm644 config/libelf.pc DESTDIR/usr/lib32/pkgconfig/libelf.pc
cp -Rv DESTDIR/usr/lib32/* /usr/lib32
rm -rf DESTDIR
