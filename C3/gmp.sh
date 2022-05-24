#!/bin/sh
source ../env.sh

name=gmp
version=6.2.1

cd /sources/src
rm -rf ${name}-${version}
tar -xf ${name}-${version}.tar.xz
cd ${name}-${version}

./configure --prefix=/usr    \
            --enable-cxx     \
            --disable-static \
            --docdir=/usr/share/doc/${name}-${version}

make -j$cpu
make html -j$cpu
make install
make install-html

##### gmp m32
unset {C,CPP,CXX,LD}FLAGS
CFLAGS="${FLAGSi686}"
CXXFLAGS="${FLAGSi686}"
LDFLAGS="${FLAGSi686}"

make distclean
cp -v configfsf.guess config.guess
cp -v configfsf.sub   config.sub
ABI="32" \
CFLAGS="-m32 -O2 -pedantic -fomit-frame-pointer -mtune=generic -march=i686" \
CXXFLAGS="$CFLAGS" \
PKG_CONFIG_PATH="/usr/lib32/pkgconfig" \
./configure                      \
    --host=i686-pc-linux-gnu     \
    --prefix=/usr                \
    --disable-static             \
    --enable-cxx                 \
    --libdir=/usr/lib32          \
    --includedir=/usr/include/m32/gmp

sed -i 's/$(exec_prefix)\/include/$\(includedir\)/' Makefile
make -j$cpu
make DESTDIR=$PWD/DESTDIR install
cp -Rv DESTDIR/usr/lib32/* /usr/lib32
cp -Rv DESTDIR/usr/include/m32/* /usr/include/m32/
rm -rf DESTDIR
