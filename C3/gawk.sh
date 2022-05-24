#!/bin/sh
source ../env.sh

name=gawk
version=5.1.1

cd /sources/src
rm -rf ${name}-${version}
tar -xf ${name}-${version}.tar.xz
cd ${name}-${version}

#### Ensure some unneeded files are not installed
sed -i 's/extras//' Makefile.in
./configure --prefix=/usr
make -j$cpu
make install
mkdir -pv                                   /usr/share/doc/${name}-${version}
cp    -v doc/{awkforai.txt,*.{eps,pdf,jpg}} /usr/share/doc/${name}-${version}
