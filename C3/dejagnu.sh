#!/bin/sh
source ../env.sh

name=dejagnu
version=1.6.3

cd /sources/src
rm -rf ${name}-${version}
tar -xf ${name}-${version}.tar.gz
cd ${name}-${version}

mkdir -v build
cd       build

../configure --prefix=/usr
makeinfo --html --no-split -o doc/dejagnu.html ../doc/dejagnu.texi
makeinfo --plaintext       -o doc/dejagnu.txt  ../doc/dejagnu.texi
make install
install -v -dm755  /usr/share/doc/${name}-${version}
install -v -m644   doc/dejagnu.{html,txt} /usr/share/doc/${name}-${version}
