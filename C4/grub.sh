#!/bin/sh
source ../env.sh

name=grub
version=2.06

cd /sources/src
rm -rf ${name}-${version}
tar -xf ${name}-${version}.tar.xz
cd ${name}-${version}

unset {C,CPP,CXX,LD}FLAGS

mkdir -pv /usr/share/fonts/unifont &&
gunzip -c ../unifont-14.0.01.pcf.gz > /usr/share/fonts/unifont/unifont.pcf
unset {C,CPP,CXX,LD}FLAGS
./configure --prefix=/usr        \
            --sysconfdir=/etc    \
            --disable-efiemu     \
            --enable-grub-mkfont \
            --with-platform=efi  \
            --disable-werror     &&
make -j1
make install &&
mv -v /etc/bash_completion.d/grub /usr/share/bash-completion/completions

install -D -m0644 /sources/lfs/other/grub.default /etc/default/grub
