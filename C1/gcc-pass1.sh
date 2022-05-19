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

mkdir -v build
cd       build

mlist=m64,m32
../configure                  \
    --target=$LFS_TGT                              \
    --prefix=$LFS/tools                            \
    --with-glibc-version=2.11                      \
    --with-sysroot=$LFS                            \
    --with-newlib                                  \
    --without-headers                              \
    --enable-initfini-array                        \
    --disable-nls                                  \
    --disable-shared                               \
    --enable-multilib --with-multilib-list=$mlist  \
    --disable-decimal-float                        \
    --disable-threads                              \
    --disable-libatomic                            \
    --disable-libgomp                              \
    --disable-libquadmath                          \
    --disable-libssp                               \
    --disable-libvtv                               \
    --disable-libstdcxx                            \
    --enable-languages=c,c++

make -j$cpu
make install

cd ..
cat gcc/limitx.h gcc/glimits.h gcc/limity.h > \
  `dirname $($LFS_TGT-gcc -print-libgcc-file-name)`/install-tools/include/limits.h
