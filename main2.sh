#!/bin/bash

source ./configlfs
LFS=${LFSDIR}

if [ "$LFS" == "" ]; then
   echo "LFS not defined" 1>&2
    exit 1
 fi

# Make sure only root can run our script
if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

cd $LFS/sources/src

chown -R root:root $LFS/{usr,lib,var,etc,bin,sbin,tools}
case $(uname -m) in
 x86_64) chown -R root:root $LFS/lib64 ;;
esac

chown -R root:root $LFS/lib32

chown -R root:root $LFS/sources

mkdir -pv $LFS/{dev,proc,sys,run}
mkdir -pv $LFS/dev/pts
chmod 755 $LFS/dev/pts

mknod -m 600 $LFS/dev/console c 5 1
mknod -m 666 $LFS/dev/null c 1 3
mknod -m 666 $LFS/dev/ptmx c 5 2

#mount -v --bind /dev/pts $LFS/dev/pts
mount --bind /dev $LFS/dev
mount -vt devpts devpts $LFS/dev/pts -o gid=5,mode=620
mount -vt proc proc $LFS/proc
mount -vt sysfs sysfs $LFS/sys
mount -vt tmpfs tmpfs $LFS/run
if [ -h $LFS/dev/shm ]; then
 mkdir -pv $LFS/$(readlink $LFS/dev/shm)
fi



chroot "$LFS" /usr/bin/env -i   \
   HOME=/root                  \
   TERM="$TERM"                \
   PS1='(lfs chroot) \# \[\e[0;36m\][\t]\[\e[0;m\] \[\e[0;32m\]\u@\h\[\e[0;m\]: \[\e[1;35m\]\w\[\e[0;m\] \[\e[1;32m\] \$\[\e[0;m\] ' \
   PATH=/usr/bin:/usr/sbin     \
   /bin/bash --login +h /sources/lfs/chrooted.sh
