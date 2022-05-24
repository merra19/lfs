#!/bin/sh
source ../env.sh

name=bzip2
version=1.0.8

cd /sources/src
rm -rf ${name}-${version}
tar -xf ${name}-${version}.tar.gz
cd ${name}-${version}

patch -Np1 -i ../bzip2-1.0.8-install_docs-1.patch

#### Ensures installation of symbolic links are relative
sed -i 's@\(ln -s -f \)$(PREFIX)/bin/@\1@' Makefile
#### Ensure the man pages are installed into the correct location
sed -i "s@(PREFIX)/man@(PREFIX)/share/man@g" Makefile

make -f Makefile-libbz2_so
make clean
make -j$cpu
make PREFIX=/usr install

cp -av libbz2.so.* /usr/lib
ln -sv libbz2.so.${version} /usr/lib/libbz2.so
cp -v bzip2-shared /usr/bin/bzip2
for i in /usr/bin/{bzcat,bunzip2}; do
  ln -sfv bzip2 $i
done
rm -fv /usr/lib/libbz2.a

##### bzip2 m32
unset {C,CPP,CXX,LD}FLAGS
export CFLAGS="${FLAGSi686}"
export CXXFLAGS="${FLAGSi686}"
export LDFLAGS="${FLAGSi686}"

make clean
sed -e "s/^CC=.*/CC=gcc -m32/" -i Makefile{,-libbz2_so}
make -f Makefile-libbz2_so
make libbz2.a
install -Dm755 libbz2.so.${version} /usr/lib32/libbz2.so.${version}
ln -sf libbz2.so.${version} /usr/lib32/libbz2.so
ln -sf libbz2.so.${version} /usr/lib32/libbz2.so.1
ln -sf libbz2.so.${version} /usr/lib32/libbz2.so.1.0
install -Dm644 libbz2.a /usr/lib32/libbz2.a
