#!/bin/sh
source ../env.sh

name=isl
version=0.24

cd /sources/src
rm -rf ${name}-${version}
tar -xf ${name}-${version}.tar.xz
cd ${name}-${version}

./configure --prefix=/usr    \
            --disable-static \
            --docdir=/usr/share/doc/${name}-${version}
make -j$cpu
make install
install -vd /usr/share/doc/${name}-${version}
install -m644 doc/{CodingStyle,manual.pdf,SubmittingPatches,user.pod} \
        /usr/share/doc/${name}-${version}
mkdir -pv /usr/share/gdb/auto-load/usr/lib
mv -v /usr/lib/libisl*gdb.py /usr/share/gdb/auto-load/usr/lib
