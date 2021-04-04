#!/bin/sh -ex

if [ -z "$1" ]; then
    echo Usage: "$0" [kernel-config]
    exit 1
fi

config="$(realpath $1)"

cd "$(dirname $0)/dep/genpatched-linux/linux/"

# Use rsync to update .config only when necessary to avoid recompilation
rsync -a "$config" .config
make menuconfig
rsync -a .config "$config"
