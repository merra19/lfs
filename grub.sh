#!/bin/sh

source ./configlfs

if [[ $EUID -ne 0 ]]; then
   echo "This script must  be run as user lfs " 1>&2
   exit 1
fi

source ./env.sh

CHECKDIR="/sources/lfs/check"
RUNDIR="/sources/lfs/C4"
SRCDIR="/sources/src"

checkdone() {

  cd $SRCDIR
  rm -rf $( ls --hide=*.tar.xz --hide=*.patch --hide=*.gz  --hide=*.bz2 --hide=*.tgz --hide=*.zip --hide=*.md5 --hide=*.pem )
  cd $RUNDIR

  if [ -e $CHECKDIR/c4/$i-$package ]; then
	echo "*** skip $package ***"
	((i=i+1))
	return 1
  else
	echo ">>> building $package <<<"
	return 0
  fi
}

set -x -E -e
mkdir -p $CHECKDIR/c4/log
cd $RUNDIR
i=0

for package in  cpio freetype mandoc efivar popt efibootmgr grub ca-certificates wget nano rust \
 linux-firmware linux-pam libcap-pam shadow-pam sudo dosfstools ; do
  checkdone || continue
  sh ./$package.sh
  echo $package > $CHECKDIR/c4/$i-$package
  ((i=i+1))
done
