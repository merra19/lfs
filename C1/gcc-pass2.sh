#!/bin/sh
source ../env.sh

name=gcc
version=12.1.0

cd $LFS/sources/src
rm -rf ${name}-${version}
tar -xf ${name}-${version}.tar.xz
cd ${name}-${version}

unset {C,CPP,CXX,LD}FLAGS

mpfrname=mpfr
mpfrvers=4.1.0
gmpname=gmp
gmpvers=6.2.1
mpcname=mpc
mpcvers=1.2.1


tar -xf ../${mpfrname}-${mpfrvers}.tar.xz
mv -v ${mpfrname}-${mpfrvers} mpfr
tar -xf ../${gmpname}-${gmpvers}.tar.xz
mv -v ${gmpname}-${gmpvers} gmp
tar -xf ../${mpcname}-${mpcvers}.tar.gz
mv -v ${mpcname}-${mpcvers} mpc

sed -e '/m64=/s/lib64/lib/' \
    -e '/m32=/s/m32=.*/m32=..\/lib32$(call if_multiarch,:i386-linux-gnu)/' \
    -i.orig gcc/config/i386/t-linux64

#### Override the building rule of libgcc and libstdc++ headers, to allow building these libraries with POSIX threads support
sed '/thread_header =/s/@.*@/gthr-posix.h/' \
    -i libgcc/Makefile.in libstdc++-v3/include/Makefile.in

mkdir -v build
cd       build

mlist=m64,m32
../configure                                       \
    --build=$(../config.guess)                     \
    --host=$LFS_TGT                                \
    --target=$LFS_TGT                              \
    LDFLAGS_FOR_TARGET=-L$PWD/$LFS_TGT/libgcc      \
    --prefix=/usr                                  \
    --with-build-sysroot=$LFS                      \
    --enable-initfini-array                        \
    --disable-nls                                  \
    --enable-multilib --with-multilib-list=$mlist  \
    --disable-decimal-float                        \
    --disable-libatomic                            \
    --disable-libgomp                              \
    --disable-libquadmath                          \
    --disable-libssp                               \
    --disable-libvtv                               \
    --enable-languages=c,c++
make -j$cpu
make DESTDIR=$LFS install
ln -sv gcc $LFS/usr/bin/cc
