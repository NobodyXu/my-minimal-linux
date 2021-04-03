#!/bin/sh -ex

cd $(dirname $0)/rootfs/

if [ ! -f init ]; then
    echo rootfs/init does not exist!
    exit 1
fi

find . | cpio --quiet -o --format='newc' | xz -C crc32 -9e -T0 >../boot/initramfs.img
