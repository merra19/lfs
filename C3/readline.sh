#!/bin/sh
source ../env.sh
source ../function.sh

name=readline
version=8.1.2

cd /sources/src
rm -rf ${name}-${version}
tar -xf ${name}-${version}.tar.gz
cd ${name}-${version}

#### Reinstalling Readline may trigger a linking bug in ldconfig
sed -i '/MV.*old/d' Makefile.in
sed -i '/{OLDSUFF}/c:' support/shlib-install

./configure --prefix=/usr    \
            --disable-static \
            --with-curses    \
            --docdir=/usr/share/doc/${name}-${version}

make SHLIB_LIBS="-lncursesw"
make SHLIB_LIBS="-lncursesw" install
install -v -m644 doc/*.{ps,pdf,html,dvi} /usr/share/doc/${name}-${version}

##### readline m32
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
make SHLIB_LIBS="-lncursesw"
make SHLIB_LIBS="-lncursesw" DESTDIR=$PWD/DESTDIR install
cp -Rv DESTDIR/usr/lib32/* /usr/lib32
rm -rf DESTDIR
