#!/bin/sh
source ../env.sh

name=ncurses
version=6.3

cd $LFS/sources/src
rm -rf ${name}-${version}
tar -xf ${name}-${version}.tar.gz
cd ${name}-${version}

sed -i s/mawk// configure
mkdir build
pushd build
  ../configure
  make -C include
  make -C progs tic
popd

./configure --prefix=/usr                \
            --host=$LFS_TGT              \
            --build=$(./config.guess)    \
            --mandir=/usr/share/man      \
            --with-manpage-format=normal \
            --with-shared                \
            --without-debug              \
            --without-ada                \
            --without-normal             \
            --disable-stripping          \
            --enable-widec

make -j$cpu
make DESTDIR=$LFS TIC_PATH=$(pwd)/build/progs/tic install
echo "INPUT(-lncursesw)" > $LFS/usr/lib/libncurses.so

######   Ncurses m32
make distclean
CC="$LFS_TGT-gcc -m32"              \
CXX="$LFS_TGT-g++ -m32"             \
./configure --prefix=/usr           \
            --host=$LFS_TGT32       \
            --build=$(./config.guess)    \
            --libdir=/usr/lib32     \
            --mandir=/usr/share/man \
            --with-shared           \
            --without-debug         \
            --without-ada           \
            --without-normal        \
            --disable-stripping     \
            --enable-widec
make -j$cpu
make DESTDIR=$PWD/DESTDIR TIC_PATH=$(pwd)/build/progs/tic install
ln -s libncursesw.so DESTDIR/usr/lib32/libcursesw.so
cp -Rv DESTDIR/usr/lib32/* $LFS/usr/lib32
rm -rf DESTDIR
