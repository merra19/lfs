#!/bin/#!/bin/sh

#### Version r11.1-22

source ./configlfs

export LFS=${LFSDIR}

# Make sure only root can run our script
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

if [ "$LFS" == "" ]; then
    echo "LFS not defined" 1>&2
    exit 1
fi

[ -d "$LFS" ] || {
   echo "LFS repository $LFS doesn't exist" 1>&2
   exit 1
}

[ -d "$SOURCEDIR" ] || {
   echo "source repository $SOURCEDIR doesn't exist" 1>&2
   exit 1
}

chmod 777 ./env.sh

mkdir -v $LFS/sources
chmod -v a+wt $LFS/sources
mkdir -v $LFS/sources/src
chmod -v a+wt $LFS/sources/src

mkdir $LFS/sources/lfs
cp * $LFS/sources/lfs -r
cd $SOURCEDIR
cp * $LFS/sources/src
cd $LFS/sources/src

mkdir -pv $LFS/{etc,var} $LFS/usr/{bin,lib,sbin}

for i in bin lib sbin; do
  ln -sv usr/$i $LFS/$i
done

case $(uname -m) in
  x86_64) mkdir -pv $LFS/lib64 ;;
esac

mkdir -pv $LFS/usr/lib32
ln -sv usr/lib32 $LFS/lib32


mkdir -pv $LFS/tools

chown -v $LFSUSER $LFS/{usr{,/*},lib,var,etc,bin,sbin,tools}
case $(uname -m) in
  x86_64) chown -v $LFSUSER $LFS/lib64 ;;
esac

cd $LFS/sources/lfs/other
cp *.patch $LFS/sources/src

chown -v $LFSUSER $LFS/lib32
chown -v $LFSUSER $LFS/sources -R

