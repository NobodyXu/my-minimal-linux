#!/bin/sh -ex

if [ -z "$1" ]; then
    echo Usage: $0 [kernel-config]
    exit 1
fi

config=$(realpath $1)

cd $(dirname $0)

mkdir -p boot
mkdir -p build_dir/usr/include/

export INSTALL_PATH=$(realpath boot)
BUILD=$(realpath build_dir)

cd dep/genpatched-linux/linux/

# Use rsync to update .config only when necessary to avoid recompilation
rsync -a $config .config

make -j $(nproc)
make install
make headers_install

exec rsync --info=progress2,stats,symsafe -aHAX --delete usr/include/ ${BUILD}/usr/include
