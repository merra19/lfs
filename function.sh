
rm_lto() {
  export CFLAGS="${FLAGS}"
  export CXXFLAGS="${FLAGS} ${FLAGSCX}"
  export LDFLAGS="${FLAGS} ${FLAGSLD}"
}

rm_O3()
{
  # https://bugs.gentoo.org/show_bug.cgi?id=50309
  if  echo ${CFLAGS} | grep -q "\-O3"  ; then
    export CFLAGS=${CFLAGS/-O3/-O2}
    export CXXFLAGS=${CXXFLAGS/-O3/-O2}
    export LDFLAGS=${LDFLAGS/-O3/-O2}
  fi
}

rm_O2()
{
  if  echo ${CFLAGS} | grep -q "\-O2"  ; then
    export CFLAGS=${CFLAGS/-O2}
    export CXXFLAGS=${CXXFLAGS/-O2/}
    export LDFLAGS=${LDFLAGS/-O2/}
  fi
}

add_ffat_lto()
{
  export CFLAGS="${CFLAGS} -ffat-lto-objects"
  export CXXFLAGS="${CXXFLAGS} -ffat-lto-objects"
  export LDFLAGS="${LDFLAGS} -ffat-lto-objects"
}

rm_semantic_interposition()
{
  if  echo ${CFLAGS} | grep -q "\-fno-semantic-interposition"  ; then
    export CFLAGS=${CFLAGS/-fno-semantic-interposition/}
    export CXXFLAGS=${CXXFLAGS/-fno-semantic-interposition/}
    export LDFLAGS=${LDFLAGS/-fno-semantic-interposition/}
  fi
}

rm_fno_common()
{
  if  echo ${CFLAGS} | grep -q "\-fno-common"  ; then
    export CFLAGS=${CFLAGS/-fno-common/}
    export CXXFLAGS=${CXXFLAGS/-fno-common/}
    export LDFLAGS=${LDFLAGS/-fno-common/}
  fi
}

rm_fno_plt()
{
  if  echo ${CFLAGS} | grep -q "\-fno-plt"  ; then
    export CFLAGS=${CFLAGS/-fno-plt/}
    export CXXFLAGS=${CXXFLAGS/-fno-plt/}
    export LDFLAGS=${LDFLAGS/-fno-plt/}
  fi
}

