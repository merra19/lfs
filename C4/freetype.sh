#!/bin/sh
source ../env.sh

name=freetype
version=2.12.1

cd /sources/src
rm -rf ${name}-${version}
tar -xf ${name}-${version}.tar.xz
cd ${name}-${version}

tar -xf ../freetype-doc-${version}.tar.xz --strip-components=2 -C docs

sed -ri "s:.*(AUX_MODULES.*valid):\1:" modules.cfg &&

sed -r "s:.*(#.*SUBPIXEL_RENDERING) .*:\1:" \
    -i include/freetype/config/ftoption.h  &&

./configure --prefix=/usr --enable-freetype-config --disable-static &&
make -j$cpu
make install

install -v -m755 -d /usr/share/doc/${name}-${version} &&
cp -v -R docs/*     /usr/share/doc/${name}-${version} &&
rm -v /usr/share/doc/${name}-${version}/freetype-config.1
