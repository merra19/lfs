#!/bin/sh

source ./configlfs

if [[ $EUID -ne 0 ]]; then
   echo "This script must  be run as user lfs " 1>&2
   exit 1
fi

export PS1='(lfs chroot) \# \[\e[0;36m\][\t]\[\e[0;m\] \[\e[0;32m\]\u@\h\[\e[0;m\]: \[\e[1;35m\]\w\[\e[0;m\] \[\e[1;32m\] \$\[\e[0;m\] '
export LTOFLAGS=${LFSLTO}

rm -f ./env.sh
cat > ./env.sh << EOF
export LFS=${LFSDIR}
export LFSUSER="${LFSUSER}"

export zonecountry="${zonecountry}"

export cpu=${LFSCPU}
export FLAGS="${LFSFLAGS}"
export FLAGSCX="${LFSCXFLAGS}"
export FLAGSi686="${LFSFLAGSX32}"
export FLAGSLD="${LFSLDFLAGS}"
export FLAGSLTO="${LFSLTO}"
EOF

cat >> ./env.sh << "EOF"

export FLTOFLAGS="${FLAGS} ${FLAGSLTO}"
export CFLAGS="${FLTOFLAGS} "
export CXXFLAGS="${FLTOFLAGS} ${FLAGSCX}"
export LDFLAGS="${FLTOFLAGS} ${FLAGSLD}"

EOF

echo "set -x -e" >> ./env.sh

source ./env.sh

CHECKDIR="/sources/lfs/check"
RUNDIR="/sources/lfs/C3"
SRCDIR="/sources/src"

checkdone() {


  cd $SRCDIR
  rm -rf $( ls --hide=*.tar.xz --hide=*.patch --hide=*.gz  --hide=*.bz2 --hide=*.tgz --hide=*.zip --hide=*.md5 --hide=*.pem )
  cd $RUNDIR

  if [ -e $CHECKDIR/c3/$i-$package ]; then
	  echo "*** skip $package ***"
	  ((i=i+1))
	  return 1
  else
    #read -p "Press enter to continue"
	  echo ">>> building $package <<<"
	  return 0
  fi
}

set -x -E -e
mkdir -p $CHECKDIR/c3/log
cd $RUNDIR
i=0

### Building LFS System

lists=(
man-pages iana-etc glibc glibc-m32 zlib bzip2 xz zstd file readline m4 bc flex
tcl expect dejagnu binutils gmp mpfr mpc isl attr acl libcap shadow gcc
pkg-config ncurses sed psmisc gettext bison grep bash libtool gdbm
gperf expat inetutils less perl XML-Parser intltool autoconf automake openssl kmod
elfutils libffi python wheel ninja meson coreutils acl-test check findutils diffutils gawk findutils
groff gzip iproute2 kbd libpipeline make patch tar texinfo vim eudev man-db procps-ng
util-linux e2fsprogs sysklogd sysvinit
)


for package in "${lists[@]}"; do
  checkdone || continue
  sh ./$package.sh 2>&1 | tee $CHECKDIR/c3/log/$package.log
  if [ $? -eq 0 ]; then
    echo "$package succeed"
  else
    echo "error :$package failed" ; exit 100
  fi
  echo $package > $CHECKDIR/c3/$i-$package
  ((i=i+1))
done
