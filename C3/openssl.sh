#!/bin/sh
source ../env.sh

name=openssl
version=3.0.3

cd /sources/src
rm -rf ${name}-${version}
tar -xf ${name}-${version}.tar.gz
cd ${name}-${version}

./config --prefix=/usr         \
         --openssldir=/etc/ssl \
         --libdir=lib          \
         shared                \
         zlib-dynamic
make -j$cpu
sed -i '/INSTALL_LIBS/s/libcrypto.a libssl.a//' Makefile
make MANSUFFIX=ssl install
mv -v /usr/share/doc/openssl /usr/share/doc/${name}-${version}
cp -vfr doc/* /usr/share/doc/${name}-${version}

##### openssl m32
unset {C,CPP,CXX,LD}FLAGS
CFLAGS="${FLAGSi686}"
CXXFLAGS="${FLAGSi686}"
LDFLAGS="${FLAGSi686}"

make distclean
CFLAGS="-m32 -march=i686 -Wall -O3" CXXFLAGS="$CFLAGS" \
./config --prefix=/usr         \
         --openssldir=/etc/ssl \
         --libdir=lib32        \
         shared                \
         zlib-dynamic          \
         linux-generic32
make -j$cpu
make DESTDIR=$PWD/DESTDIR install
cp -Rv DESTDIR/usr/lib32/* /usr/lib32
rm -rf DESTDIR
