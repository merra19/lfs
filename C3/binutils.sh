#!/bin/sh
source ../env.sh

name=binutils
version=2.38

cd /sources/src
rm -rf ${name}-${version}
tar -xf ${name}-${version}.tar.xz
cd ${name}-${version}

expect -c "spawn ls"
if [ $? -eq 0 ]; then
    echo "expect success "
else
    echo "error" ; exit 100
fi

#read -p "Press enter to continue >>  spawn ls  <<"

patch -Np1 -i ../binutils-2.38-lto_fix-1.patch

#### Fix identified upstream that affects building some packages
sed -e '/R_386_TLS_LE /i \   || (TYPE) == R_386_TLS_IE \\' \
    -i ./bfd/elfxx-x86.h

mkdir -v build
cd       build

../configure --prefix=/usr       \
             --enable-gold       \
             --enable-ld=default \
             --enable-plugins    \
             --enable-install-libiberty \
             --enable-relro      \
             --enable-shared     \
             --disable-werror    \
             --enable-64-bit-bfd \
             --with-system-zlib  \
             --enable-multilib

make tooldir=/usr -j$cpu
make tooldir=/usr install -j1
rm -fv /usr/lib/lib{bfd,ctf,ctf-nobfd,opcodes}.a
