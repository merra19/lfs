#!/bin/sh
source ../env.sh

name=ncurses
version=6.3

cd /sources/src
rm -rf ${name}-${version}
tar -xf ${name}-${version}.tar.gz
cd ${name}-${version}

./configure --prefix=/usr           \
            --mandir=/usr/share/man \
            --with-shared           \
            --without-debug         \
            --without-normal        \
            --enable-pc-files       \
            --enable-widec          \
            --with-pkg-config-libdir=/usr/lib/pkgconfig

make -j$cpu
make DESTDIR=$PWD/dest install
install -vm755 dest/usr/lib/libncursesw.so.${version} /usr/lib
rm -v  dest/usr/lib/{libncursesw.so.${version},libncurses++w.a}
cp -av dest/* /

for lib in ncurses form panel menu ; do
    rm -vf                    /usr/lib/lib${lib}.so
    echo "INPUT(-l${lib}w)" > /usr/lib/lib${lib}.so
    ln -sfv ${lib}w.pc        /usr/lib/pkgconfig/${lib}.pc
done

rm -vf                     /usr/lib/libcursesw.so
echo "INPUT(-lncursesw)" > /usr/lib/libcursesw.so
ln -sfv libncurses.so      /usr/lib/libcurses.so

mkdir -pv      /usr/share/doc/${name}-${version}
cp -v -R doc/* /usr/share/doc/${name}-${version}

##### ncurses m32
unset {C,CPP,CXX,LD}FLAGS
CFLAGS="${FLAGSi686}"
CXXFLAGS="${FLAGSi686}"
LDFLAGS="${FLAGSi686}"

make distclean
CC="gcc -m32" CXX="g++ -m32" \
./configure --prefix=/usr           \
            --host=i686-pc-linux-gnu \
            --libdir=/usr/lib32     \
            --mandir=/usr/share/man \
            --with-shared           \
            --without-debug         \
            --without-normal        \
            --enable-pc-files       \
            --enable-widec          \
            --with-pkg-config-libdir=/usr/lib32/pkgconfig
make -j$cpu
make DESTDIR=$PWD/DESTDIR install
mkdir -p DESTDIR/usr/lib32/pkgconfig
for lib in ncurses form panel menu ; do
    rm -vf                    DESTDIR/usr/lib32/lib${lib}.so
    echo "INPUT(-l${lib}w)" > DESTDIR/usr/lib32/lib${lib}.so
    ln -svf ${lib}w.pc        DESTDIR/usr/lib32/pkgconfig/$lib.pc
done
rm -vf                     DESTDIR/usr/lib32/libcursesw.so
echo "INPUT(-lncursesw)" > DESTDIR/usr/lib32/libcursesw.so
ln -sfv libncurses.so      DESTDIR/usr/lib32/libcurses.so
cp -Rv DESTDIR/usr/lib32/* /usr/lib32
rm -rf DESTDIR
