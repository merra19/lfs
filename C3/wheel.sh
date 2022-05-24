#!/bin/sh
source ../env.sh

name=wheel
version=0.37.1

cd /sources/src
rm -rf ${name}-${version}
tar -xf ${name}-${version}.tar.gz
cd ${name}-${version}

pip3 install --no-index $PWD
