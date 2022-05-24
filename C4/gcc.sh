#!/bin/sh
source ../env.sh
source ../function.sh

name=gcc
version=12.1.0

cd /sources/src
rm -rf ${name}-${version}
tar -xf ${name}-${version}.tar.xz
cd ${name}-${version}

rm_lto

#### change the default directory name for 64-bit libraries to “lib”
sed -e '/m64=/s/lib64/lib/' \
    -e '/m32=/s/m32=.*/m32=..\/lib32$(call if_multiarch,:i386-linux-gnu)/' \
    -i.orig gcc/config/i386/t-linux64

mkdir -v build
cd       build

mlist=m64,m32
../configure --prefix=/usr               \
             --enable-languages=c,c++,fortran,go,objc,obj-c++    \
             --enable-multilib           \
             --with-multilib-list=$mlist \
             --with-system-zlib

make -j$cpu

make install
rm -rf /usr/lib/gcc/$(gcc -dumpmachine)/${version}/include-fixed/bits/
chown -v -R root:root \
    /usr/lib/gcc/*linux-gnu/${version}/include{,-fixed}
ln -svr /usr/bin/cpp /usr/lib
#### Add a compatibility symlink to enable building programs with Link Time Optimization (LTO)
ln -sfv ../../libexec/gcc/$(gcc -dumpmachine)/${version}/liblto_plugin.so \
        /usr/lib/bfd-plugins/

echo 'int main(){}' > dummy.c
cc dummy.c -v -Wl,--verbose &> dummy.log
readelf -l a.out | grep ': /lib'
if [ $? -eq 0 ]; then
    echo "/lib found "
else
    echo "error" ; exit 100
fi

#read -p "Press enter to continue >>  /lib64/ld-linux-x86-64.so.2"

grep -o '/usr/lib.*/crt[1in].*succeeded' dummy.log
if [ $? -eq 0 ]; then
    echo "/usr/lib.*/crt[1in].* found "
else
    echo "error" ; exit 100
fi

#read -p "Press enter to continue >> /usr/lib/gcc/x86_64-pc-linux-gnu/${version}/../../../../lib/crt1.o succ x3"

grep -B4 '^ /usr/include' dummy.log
if [ $? -eq 0 ]; then
    echo "/usr/include found "
else
    echo "error" ; exit 100
fi

#read -p "Press enter to continue >> include "

grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g'
if [ $? -eq 0 ]; then
    echo "*/usr/lib found "
else
    echo "error" ; exit 100
fi

#read -p "Press enter to continue"

grep "/lib.*/libc.so.6 " dummy.log
if [ $? -eq 0 ]; then
    echo "/lib.*/libc.so.6  found "
else
    echo "error" ; exit 100
fi

#read -p "Press enter to continue >> /usr/lib/libc.so.6 succeeded"

grep found dummy.log
if [ $? -eq 0 ]; then
    echo "found /usr/lib/ld-linux-x86-64.so.2"
else
    echo "error" ; exit 100
fi

#read -p "Press enter to continue >> found /usr/lib/ld-linux-x86-64.so.2"
rm -v dummy.c a.out dummy.log

mkdir -pv /usr/share/gdb/auto-load/usr/lib
mv -v /usr/lib/*gdb.py /usr/share/gdb/auto-load/usr/lib
