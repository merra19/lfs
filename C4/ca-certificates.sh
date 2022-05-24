#!/bin/sh
source ../env.sh

name=ca-certificates
version=20220329
_noyear=${version#????}
_version=${version%????}-${_noyear%??}-${version#??????}

cd /sources/src
install -Dm644 cacert-$_version.pem /etc/ssl/cert.pem

install -d /etc/ssl/certs
ln -s /etc/ssl/cert.pem /etc/ssl/certs/ca-certificates.crt
ln -s /etc/ssl/cert.pem /etc/ssl/ca-bundle.crt
