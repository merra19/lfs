#!/bin/sh
source ../env.sh

name=linux-firmware
version=20220509

cd /sources/src
rm -rf ${name}-${version}
tar -xf ${name}-${version}.tar.gz
cd ${name}-${version}

mkdir -pv /lib/firmware/
mv -v *  /lib/firmware/

chown root:root /lib/firmware/ -R
