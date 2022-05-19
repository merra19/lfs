#!/bin/sh
source ../env.sh

name=gettext
version=0.21

cd /sources/src
rm -rf ${name}-${version}
tar -xf ${name}-${version}.tar.xz
cd ${name}-${version}

./configure --disable-shared
make -j$cpu
make install
cp -v gettext-tools/src/{msgfmt,msgmerge,xgettext} /usr/bin
