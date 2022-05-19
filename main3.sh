#!/bin/sh

source ./configlfs

if [[ $EUID -ne 0 ]]; then
   echo "This script must  be run as root " 1>&2
   exit 1
fi

cat > ./env.sh << EOF
export LFS=${LFSDIR}
export LFSUSER="${LFSUSER}"

export cpu=${LFSCPU}

EOF

cat >> ./env.sh << "EOF"
export FLAGS=" -pipe -O2"
export CFLAGS="${FLAGS}"
export CXXFLAGS="${CFLAGS}"
export LDFLAGS="${CFLAGS}"

set +h
umask 022
LC_ALL=POSIX
LFS_TGT=x86_64-lfs-linux-gnu
LFS_TGT32=i686-lfs-linux-gnu
LFS_TGTX32=x86_64-lfs-linux-gnux32
PATH=/usr/bin
if [ ! -L /bin ]; then PATH=/bin:$PATH; fi
PATH=$LFS/tools/bin:$PATH
CONFIG_SITE=$LFS/usr/share/config.site
export LC_ALL LFS_TGT LFS_TGT32 LFS_TGTX32 PATH

EOF

source ./env.sh

CHECKDIR="/sources/lfs/check"
RUNDIR="/sources/lfs/C2"
SRCDIR="/sources/src"

checkdone() {

  cd $SRCDIR
  rm -rf $( ls --hide=*.tar.xz --hide=*.patch --hide=*.gz  --hide=*.bz2 --hide=*.tgz --hide=*.zip --hide=*.md5 --hide=*.pem )
  cd $RUNDIR

  if [ -e $CHECKDIR/c2/$i-$package ]; then
	echo "*** skip $package ***"
	((i=i+1))
	return 1
  else
	echo ">>> building $package <<<"
	return 0
  fi
}

set -x -E -e
mkdir -p $CHECKDIR/c2/log
cd $RUNDIR
i=0

### Cross Tool-chain

for package in gettext bison perl python texinfo util-linux zstd ; do
  checkdone || continue
  sh ./$package.sh
  echo $package > $CHECKDIR/c2/$i-$package
  ((i=i+1))
done


#### clean-up
rm -rf /usr/share/{info,man,doc}/*
find /usr/{lib,libexec} -name \*.la -delete
find /usr/lib32 -name \*.la -delete
rm -rf /tools

echo " you can backup now , exit CHROOT"
echo "umount $LFS/dev/pts $LFS/{sys,proc,run,dev}"
