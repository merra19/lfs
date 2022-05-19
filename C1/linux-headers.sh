#!/bin/sh
source ../env.sh

name=linux
version=${kernelvers}

cd $LFS/sources/src
rm -rf ${name}-${version}
tar -xf ${name}-${version}.tar.xz
cd ${name}-${version}

echo ${version}

make mrproper
make headers
find usr/include -name '.*' -delete
rm usr/include/Makefile
cp -rv usr/include $LFS/usr
