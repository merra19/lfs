#!/bin/sh
source ../env.sh

name=XML-Parser
version=2.46

cd /sources/src
rm -rf ${name}-${version}
tar -xf ${name}-${version}.tar.gz
cd ${name}-${version}

perl Makefile.PL
make -j$cpu
make install
