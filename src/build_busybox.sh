#!/bin/sh -ex

EXE=$(realpath $0)

if [ -z "$1" ]; then
    echo Usage: $0 [busybox-config]
    exit 1
fi

config=$(realpath $1)

cd $(dirname $0)

mkdir -p rootfs

ROOTFS=$(realpath rootfs)
SYSROOT=$(realpath build_dir)

cd dep/linux-pam/

if [ ! -f ./configure ] || [ ./autogen.sh -nt ./configure ]; then
    ./autogen.sh
fi

export CC=${SYSROOT}/usr/bin/musl-clang
export CFLAGS="-march=native -mtune=native -Oz -flto"
export LDFLAGS='-flto -fuse-ld=musl-clang-lld-static -Wl,--plugin-opt=O3,-O3,--gc-sections,--icf=safe'
export PKG_CONFIG="${SYSROOT}/usr/bin/musl-pkg-config"

if [ ! -f config.status ] || [ "$EXE" -nt config.status ]; then
    ./configure --prefix=${SYSROOT}/usr/ \
        --enable-static=yes \
        --enable-shared=no \
        --disable-pie \
        --disable-doc \
        --enable-db=no \
        --disable-lckpwdf \
        --disable-audit \
        --disable-nis \
        --disable-selinux \
        --disable-econf \
        --disable-nls
fi

make -j $(nproc)
make install

cd ../busybox

# Use rsync to update .config only when necessary to avoid recompilation
rsync -a $config .config

CCPREFIX=$(echo "${SYSROOT}/usr/bin/musl-" | sed 's/\//\\\//g')
CONFIG_SYSROOT=$(echo "$SYSROOT" | sed 's/\//\\\//g')

sed -i "s/CONFIG_CROSS_COMPILER_PREFIX=.*/CONFIG_CROSS_COMPILER_PREFIX=\"$CCPREFIX\"/" .config
sed -i "s/CONFIG_SYSROOT=.*/CONFIG_SYSROOT=\"$CONFIG_SYSROOT\"/" .config

#export CONFIG_SYSROOT="$SYSROOT"

make -j $(nproc)
make install

cp -r _install/* "$ROOTFS"
