#!/bin/sh
source ../env.sh

name=util-linux
version=2.38

cd /sources/src
rm -rf ${name}-${version}
tar -xf ${name}-${version}.tar.xz
cd ${name}-${version}

mkdir -pv /var/lib/hwclock

./configure ADJTIME_PATH=/var/lib/hwclock/adjtime    \
            --libdir=/usr/lib    \
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
            runstatedir=/run
make -j$cpu
make install

##### util-linux m32
make distclean
CC="gcc -m32" \
./configure ADJTIME_PATH=/var/lib/hwclock/adjtime    \
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
            --libdir=/usr/lib32      \
            --host=i686-pc-linux-gnu
make -j$cpu
make DESTDIR=$PWD/DESTDIR install
cp -Rv DESTDIR/usr/lib32/* /usr/lib32
rm -rf DESTDIR
