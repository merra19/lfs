#!/bin/sh
source ../env.sh

name=glibc
version=2.35
versiongcc=12.1.0

cd $LFS/sources/src
rm -rf ${name}-${version}
tar -xf ${name}-${version}.tar.xz
cd ${name}-${version}

ln -sfv ../lib/ld-linux-x86-64.so.2 $LFS/lib64
ln -sfv ../lib/ld-linux-x86-64.so.2 $LFS/lib64/ld-lsb-x86-64.so.3

patch -Np1 -i ../glibc-2.35-fhs-1.patch

mkdir -v build
cd       build
echo "rootsbindir=/usr/sbin" > configparms

../configure                             \
      --prefix=/usr                      \
      --host=$LFS_TGT                    \
      --build=$(../scripts/config.guess) \
      --enable-kernel=3.2                \
      --with-headers=$LFS/usr/include    \
      --enable-multi-arch                \
      libc_cv_slibdir=/usr/lib

make -j$cpu
make DESTDIR=$LFS install

sed '/RTLDLIST=/s@/usr@@g' -i $LFS/usr/bin/ldd

echo 'int main(){}' > dummy.c
$LFS_TGT-gcc dummy.c
readelf -l a.out | grep '/ld-linux'
rm -v dummy.c a.out
status=$?
[ $status -eq 0 ] && echo "command successful" || exit 100

$LFS/tools/libexec/gcc/$LFS_TGT/${versiongcc}/install-tools/mkheaders

##### glibc m32
make clean
find .. -name "*.a" -delete

CC="$LFS_TGT-gcc -m32" \
CXX="$LFS_TGT-g++ -m32" \
../configure                             \
      --prefix=/usr                      \
      --host=$LFS_TGT32                  \
      --build=$(../scripts/config.guess) \
      --enable-kernel=3.2                \
      --with-headers=$LFS/usr/include    \
      --enable-multi-arch                \
      --libdir=/usr/lib32                \
      --libexecdir=/usr/lib32            \
      libc_cv_slibdir=/usr/lib32

make -j$cpu
make DESTDIR=$PWD/DESTDIR install
cp -a DESTDIR/usr/lib32 $LFS/usr/
install -vm644 DESTDIR/usr/include/gnu/{lib-names,stubs}-32.h \
               $LFS/usr/include/gnu/
ln -svf ../lib32/ld-linux.so.2 $LFS/lib/ld-linux.so.2

echo 'int main(){}' > dummy.c
$LFS_TGT-gcc -m32 dummy.c
readelf -l a.out | grep '/ld-linux'
rm -v dummy.c a.out
status=$?
[ $status -eq 0 ] && echo "command successful" || exit 100
