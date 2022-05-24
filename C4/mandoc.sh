#!/bin/sh
source ../env.sh

name=mandoc
version=1.14.6

cd /sources/src
rm -rf ${name}-${version}
tar -xf ${name}-${version}.tar.gz
cd ${name}-${version}

./configure &&
make mandoc
install -vm755 mandoc   /usr/bin &&
install -vm644 mandoc.1 /usr/share/man/man1
