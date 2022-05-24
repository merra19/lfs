#!/bin/sh
source ../env.sh

name=efibootmgr
version=17

cd /sources/src
rm -rf ${name}-${version}
tar -xf ${name}-${version}.tar.gz
cd ${name}-${version}

unset {C,CPP,CXX,LD}FLAGS

#### Fix an outdated hotfix declaration causing compilation failure
sed -e '/extern int efi_set_verbose/d' -i src/efibootmgr.c
### Fix an issue building this package with efivar-38 or later
sed 's/-Werror//' -i Make.defaults

make EFIDIR=LFS EFI_LOADER=grubx64.efi
make install EFIDIR=LFS
