source ../env.sh

name=sudo
version=1.9.10

cd /sources/src/
tar -xf ${name}-${version}.tar.gz
cd ${name}-${version}

./configure --prefix=/usr              \
            --libexecdir=/usr/lib      \
            --with-secure-path         \
            --with-all-insults         \
            --with-env-editor          \
            --docdir=/usr/share/doc/${name}-${version} \
            --with-passprompt="[sudo] password for %p: " &&
make -j$cpu
make install &&
ln -sfv libsudo_util.so.0.0.0 /usr/lib/sudo/libsudo_util.so.0

cat > /etc/sudoers.d/00-sudo << EOF &&
Defaults secure_path="/usr/sbin:/usr/bin"
%wheel ALL=(ALL) ALL

$LFSUSER  ALL=(ALL) NOPASSWD:ALL

EOF

cat > /etc/pam.d/sudo << "EOF" &&
# Begin /etc/pam.d/sudo

# include the default auth settings
auth      include     system-auth

# include the default account settings
account   include     system-account

# Set default environment variables for the service user
session   required    pam_env.so

# include system session defaults
session   include     system-session

# End /etc/pam.d/sudo
EOF
chmod 644 /etc/pam.d/sudo
