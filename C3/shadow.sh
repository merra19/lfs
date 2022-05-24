#!/bin/sh
source ../env.sh
source ../function.sh

name=shadow
version=4.11.1

cd /sources/src
rm -rf ${name}-${version}
tar -xf ${name}-${version}.tar.xz
cd ${name}-${version}

rm_lto

#### Disable the installation of the groups program and its man pages
####  as Coreutils provides a better version
sed -i 's/groups$(EXEEXT) //' src/Makefile.in
find man -name Makefile.in -exec sed -i 's/groups\.1 / /'   {} \;
find man -name Makefile.in -exec sed -i 's/getspnam\.3 / /' {} \;
find man -name Makefile.in -exec sed -i 's/passwd\.5 / /'   {} \;

#### Use the more secure SHA-512 method
sed -e 's:#ENCRYPT_METHOD DES:ENCRYPT_METHOD SHA512:' \
    -e 's:/var/spool/mail:/var/mail:'                 \
    -e '/PATH=/{s@/sbin:@@;s@/bin:@@}'                \
    -i etc/login.defs

touch /usr/bin/passwd
./configure --sysconfdir=/etc \
            --disable-static  \
            --with-group-name-max-length=32

make -j$cpu
make exec_prefix=/usr install
make -C man install-man
mkdir -p /etc/default
useradd -D --gid 999

pwconv
grpconv
sed -i 's/yes/no/' /etc/default/useradd
passwd root
