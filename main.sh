#!/bin/bash

source ./configlfs
export LFS=${LFSDIR}

if [ "$LFS" == "" ]; then
   echo "LFS not defined " 1>&2
   exit 1
fi

if [[ $EUID -eq 0 ]]; then
   echo "This script must  be run as user lfs " 1>&2
   exit 1
fi

if [ "$(whoami)" != "tara" ]; then
        echo "script must be run as user: lfs "
        exit 255
fi

[ -d "$LFS/sources" ] || {
   echo "$LFS/sources doesn't exist" 1>&2
   exit 1
}

MAINDIR="$LFS/sources"
CHECKDIR="$MAINDIR/lfs/check"
RUNDIR="$MAINDIR/lfs/C1"
SRCDIR="$MAINDIR/src"

cd $MAINDIR/lfs

cat > ./env.sh << EOF
export LFS=${LFSDIR}
export LFSUSER="${LFSUSER}"

export cpu=${LFSCPU}
export kernelvers=${KERNELVERSION}

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

echo $LFSVERSION
sleep 5

checkdone() {

  cd $SRCDIR
  rm -rf $( ls --hide=*.tar.xz --hide=*.patch --hide=*.gz  --hide=*.bz2 --hide=*.tgz --hide=*.zip --hide=*.md5 --hide=*.pem  )
  cd $RUNDIR

  if [ -e $CHECKDIR/c1/$i-$package ]; then
	echo "*** skip $package ***"
	((i=i+1))
	return 1
  else
	echo ">>> building $package <<<"
	return 0
  fi
}

set -x -E -e
mkdir -p $CHECKDIR/c1/log
cd $RUNDIR
i=0

export LC_ALL=C

mkdir -pv $LFS/var/lib/scratchpkg/db

### Cross Tool-chain

for package in binutils-pass1 gcc-pass1 linux-headers glibc libstdc m4 ncurses bash coreutils ; do
  checkdone || continue
  sh ./$package.sh 2>&1
  echo $package > $CHECKDIR/c1/$i-$package
  ((i=i+1))
done

for package in diffutils file findutils gawk grep gzip make patch sed tar xz binutils-pass2 gcc-pass2 ; do
  checkdone || continue
  sh ./$package.sh 2>&1
  echo $package > $CHECKDIR/c1/$i-$package
  ((i=i+1))
done
