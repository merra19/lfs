#!/bin/sh
source ../env.sh

name=man-pages
version=5.13

cd /sources/src
rm -rf ${name}-${version}
tar -xf ${name}-${version}.tar.xz
cd ${name}-${version}

make prefix=/usr install
