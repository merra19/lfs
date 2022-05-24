#!/bin/sh
source ../env.sh

name=iproute2
version=5.17.0

cd /sources/src
rm -rf ${name}-${version}
tar -xf ${name}-${version}.tar.xz
cd ${name}-${version}

#### Remove arpd since it is dependent on Berkeley DB
sed -i /ARPD/d Makefile
rm -fv man/man8/arpd.8

make -j$cpu
make SBINDIR=/usr/sbin install
mkdir -pv             /usr/share/doc/${name}-${version}
cp -v COPYING README* /usr/share/doc/${name}-${version}
