#!/bin/sh
source ../env.sh
source ../function.sh

name=Python
version=3.10.4

cd /sources/src
rm -rf ${name}-${version}
tar -xf ${name}-${version}.tar.xz
cd ${name}-${version}

####  add lto
add_ffat_lto
rm_O3

CFLAGS+=" -fno-semantic-interposition"
CXXFLAGS+=" -fno-semantic-interposition"
LDFLAGS+=" -fno-semantic-interposition"

./configure --prefix=/usr        \
            --enable-shared      \
            --with-system-expat  \
            --with-system-ffi    \
            --enable-optimizations
make -j$cpu
make install

sed -e '/def warn_if_run_as_root/a\    return' \
    -i /usr/lib/python3.10/site-packages/pip/_internal/cli/req_command.py

install -v -dm755 /usr/share/doc/${name}-${version}/html

tar --strip-components=1  \
    --no-same-owner       \
    --no-same-permissions \
    -C /usr/share/doc/${name}-${version}/html \
    -xvf ../python-${version}-docs-html.tar.bz2
