#!/bin/sh
source ../env.sh
source ../function.sh

name=cpio
version=2.13

cd /sources/src
rm -rf ${name}-${version}
tar -xf ${name}-${version}.tar.bz2
cd ${name}-${version}

#### Fix a build issue when using GCC-10 and higher
sed -i '/The name/,+2 d' src/global.c

rm_lto

./configure --prefix=/usr \
            --enable-mt   \
            --with-rmt=/usr/libexec/rmt &&
make &&
makeinfo --html            -o doc/html      doc/cpio.texi &&
makeinfo --html --no-split -o doc/cpio.html doc/cpio.texi &&
makeinfo --plaintext       -o doc/cpio.txt  doc/cpio.texi

make install &&
install -v -m755 -d /usr/share/doc/${name}-${version}/html &&
install -v -m644    doc/html/* \
                    /usr/share/doc/${name}-${version}/html &&
install -v -m644    doc/cpio.{html,txt} \
                    /usr/share/doc/${name}-${version}
