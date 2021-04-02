#!/bin/sh -ex

if [ -z "$1" ]; then
    echo Usage: $0 [busybox-config]
    exit 1
fi

config=$(realpath $1)

cd $(dirname $0)

mkdir -p rootfs

ROOTFS=$(realpath rootfs)
SYSROOT=$(realpath build_dir)

cd dep/busybox

# Use rsync to update .config only when necessary to avoid recompilation
rsync -a $config .config

CCPREFIX=$(echo "${SYSROOT}/usr/bin/musl-" | sed 's/\//\\\//g')
CONFIG_SYSROOT=$(echo "$SYSROOT" | sed 's/\//\\\//g')

sed -i "s/CONFIG_CROSS_COMPILER_PREFIX=.*/CONFIG_CROSS_COMPILER_PREFIX=\"$CCPREFIX\"/" .config
sed -i "s/CONFIG_SYSROOT=.*/CONFIG_SYSROOT=\"$CONFIG_SYSROOT\"/" .config

#export CONFIG_SYSROOT="$SYSROOT"

make #-j $(nproc)
CONFIG_PREFIX="ROOTFS" make install


