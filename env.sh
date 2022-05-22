export LFS=/mnt/lfs
export LFSUSER="merry19"

export cpu=10

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

