#!/bin/sh
source ../env.sh

name=sysvinit
version=3.04

cd /sources/src
rm -rf ${name}-${version}
tar -xf ${name}-${version}.tar.xz
cd ${name}-${version}

patch -Np1 -i ../sysvinit-3.04-consolidated-1.patch
make
make install
