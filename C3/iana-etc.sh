#!/bin/sh
source ../env.sh

name=iana-etc
version=20220207

cd /sources/src
rm -rf ${name}-${version}
tar -xf ${name}-${version}.tar.gz
cd ${name}-${version}

cp services protocols /etc
