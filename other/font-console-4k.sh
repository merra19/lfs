#!/bin/sh

source ../env.sh


#### font 4K
cd /sources/src
tar -xf terminus-font-4.49.1.tar.gz
cd terminus-font-4.49.1
make psf
gzip ter-v32n.psf
install -v -m644 ter-v32n.psf.gz /usr/share/consolefonts
#sed  -i 's/consolefont="default8x16"/consolefont="ter-v32n"/' /etc/conf.d/consolefont

