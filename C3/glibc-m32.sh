#!/bin/sh
source ../env.sh

name=glibc
version=2.35

cd /sources/src
rm -rf ${name}-${version}
tar -xf ${name}-${version}.tar.xz
cd ${name}-${version}

unset {C,CPP,CXX,LD}FLAGS
CFLAGS="${FLAGSi686}"
CXXFLAGS="${FLAGSi686}"
LDFLAGS="${FLAGSi686}"

patch -Np1 -i ../glibc-2.35-fhs-1.patch

mkdir -v build
cd       build

echo "CFLAGS += $CFLAGS" > configparms

CC="gcc -m32" CXX="g++ -m32" \
../configure                             \
      --prefix=/usr                      \
      --host=i686-pc-linux-gnu           \
      --build=$(../scripts/config.guess) \
      --enable-kernel=3.2                \
      --with-headers=/usr/include        \
      --enable-multi-arch                \
      --libdir=/usr/lib32                \
      --libexecdir=/usr/lib32            \
      libc_cv_slibdir=/usr/lib32

make -j$cpu
make DESTDIR=$PWD/DESTDIR install
cp -a DESTDIR/usr/lib32/* /usr/lib32/
install -vm644 DESTDIR/usr/include/gnu/{lib-names,stubs}-32.h \
               /usr/include/gnu/
echo "/usr/lib32" >> /etc/ld.so.conf
echo 'int main(){}' > dummy.c
gcc -m32 dummy.c
readelf -l a.out | grep '/ld-linux'
if [ $? -eq 0 ]; then
    echo "/lib/ld-linux.so.2  m32 found "
else
    echo "error" ; exit 100
fi
rm -v dummy.c a.out
echo "[Requesting program interpreter: /lib/ld-linux.so.2]"
#read -p "Press enter to continue"
