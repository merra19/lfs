#!/bin/sh
source ../env.sh

name=efivar
version=38

cd /sources/src
rm -rf ${name}-${version}
tar -xf ${name}-${version}.tar.bz2
cd ${name}-${version}

unset {C,CPP,CXX,LD}FLAGS

#### Fix an issue in Makefile causing the package to be rebuilt during installation
sed '/prep :/a\\ttouch prep' -i src/Makefile
make
make install LIBDIR=/usr/lib
