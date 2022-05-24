#!/bin/sh
source ../env.sh

name=rust
version=1.60.0

cd /sources/src
rm -rf ${name}-${version}-x86_64-unknown-linux-gnu
tar -xf /sources/src/${name}-${version}-x86_64-unknown-linux-gnu.tar.gz
cd ${name}-${version}-x86_64-unknown-linux-gnu

mkdir -v /opt/${name}-${version} && ln -svfin ${name}-${version} /opt/rustc

./install.sh --prefix=/opt/rustc --sysconfdir=/etc --mandir=/usr/share/man \
--components=rustc,cargo,rust-std-x86_64-unknown-linux-gnu,\
rust-analysis-x86_64-unknown-linux-gnu && ldconfig

ln -sf /opt/rustc/bin/cargo  /usr/bin/cargo
ln -sf /opt/rustc/bin/rustc  /usr/bin/rustc

mkdir /etc/profile.d/
cat > /etc/profile.d/rustc.sh << "EOF"
## Rust Compiler Environment

if [ -d /opt/rustc ]; then
   pathappend /opt/rustc/bin
fi
EOF

echo '/opt/rustc/lib' >> /etc/ld.so.conf.d/rust
