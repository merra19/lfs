#!/bin/sh
source ../env.sh

name=util-linux
version=2.38

cd /sources/src
rm -rf ${name}-${version}
tar -xf ${name}-${version}.tar.xz
cd ${name}-${version}

./configure ADJTIME_PATH=/var/lib/hwclock/adjtime   \
            --bindir=/usr/bin    \
            --libdir=/usr/lib    \
            --sbindir=/usr/sbin  \
            --docdir=/usr/share/doc/${name}-${version} \
            --disable-chfn-chsh  \
            --disable-login      \
            --disable-nologin    \
            --disable-su         \
            --disable-setpriv    \
            --disable-runuser    \
            --disable-pylibmount \
            --disable-static     \
            --without-python     \
            --without-systemd    \
            --without-systemdsystemunitdir
make -j$cpu
make install

#### util-linux m32
unset {C,CPP,CXX,LD}FLAGS
CFLAGS="${FLAGSi686}"
CXXFLAGS="${FLAGSi686}"
LDFLAGS="${FLAGSi686}"

make distclean
mv /usr/bin/ncursesw6-config{,.tmp}
CC="gcc -m32" \
./configure ADJTIME_PATH=/var/lib/hwclock/adjtime   \
            --host=i686-pc-linux-gnu \
            --libdir=/usr/lib32      \
            --docdir=/usr/share/doc/${name}-${version} \
            --disable-chfn-chsh      \
            --disable-login          \
            --disable-nologin        \
            --disable-su             \
            --disable-setpriv        \
            --disable-runuser        \
            --disable-pylibmount     \
            --disable-static         \
            --without-python         \
            --without-systemd        \
            --without-systemdsystemunitdir
mv /usr/bin/ncursesw6-config{.tmp,}
make -j$cpu
make DESTDIR=$PWD/DESTDIR install
cp -Rv DESTDIR/usr/lib32/* /usr/lib32
rm -rf DESTDIR
