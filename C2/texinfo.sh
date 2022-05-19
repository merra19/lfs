#!/bin/sh
source ../env.sh

name=texinfo
version=6.8

cd /sources/src
rm -rf ${name}-${version}
tar -xf ${name}-${version}.tar.xz
cd ${name}-${version}

#### fix an issue building the package with Glibc-2.34 or later
sed -e 's/__attribute_nonnull__/__nonnull/' \
    -i gnulib/lib/malloc/dynarray-skeleton.c

./configure --prefix=/usr

make -j$cpu
make install
