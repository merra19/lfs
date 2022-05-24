#!/bin/sh
source ../env.sh

name=eudev
version=3.2.11
nameudev=udev-lfs
versudev=20171102

cd /sources/src
rm -rf ${name}-${version}
tar -xf ${name}-${version}.tar.gz
cd ${name}-${version}

./configure --prefix=/usr           \
            --bindir=/usr/sbin      \
            --sysconfdir=/etc       \
            --enable-manpages       \
            --disable-static
make -j$cpu
mkdir -pv /usr/lib/udev/rules.d
mkdir -pv /etc/udev/rules.d
make install
tar -xvf ../${nameudev}-${versudev}.tar.xz
make -f ${nameudev}-${versudev}/Makefile.lfs install

##### eudev m32
unset {C,CPP,CXX,LD}FLAGS
CFLAGS="${FLAGSi686}"
CXXFLAGS="${FLAGSi686}"
LDFLAGS="${FLAGSi686}"

make distclean
CC="gcc -m32" \
./configure --host=i686-pc-linux-gnu       \
            --prefix=/usr                  \
            --bindir=/usr/sbin             \
            --libdir=/usr/lib32            \
            --sysconfdir=/etc              \
            --disable-manpages             \
            --disable-static               \
            --config-cache
make -j$cpu
make DESTDIR=$PWD/DESTDIR install
cp -Rv DESTDIR/usr/lib32/* /usr/lib32
rm -rf DESTDIR

udevadm hwdb --update
