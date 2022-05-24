#!/bin/sh
source ../env.sh

name=kbd
version=2.4.0

cd /sources/src
rm -rf ${name}-${version}
tar -xf ${name}-${version}.tar.xz
cd ${name}-${version}

patch -Np1 -i ../kbd-2.4.0-backspace-1.patch

#### Remove the redundant resizecons program
sed -i '/RESIZECONS_PROGS=/s/yes/no/' configure
sed -i 's/resizecons.8 //' docs/man/man8/Makefile.in
./configure --prefix=/usr --disable-vlock
make -j$cpu
make install
mkdir -pv           /usr/share/doc/${name}-${version}
cp -R -v docs/doc/* /usr/share/doc/${name}-${version}
