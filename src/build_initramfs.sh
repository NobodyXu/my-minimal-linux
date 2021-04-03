#!/bin/sh -ex

cd $(dirname $0)/rootfs/
find . | cpio --quiet -o --format='newc' | xz -C crc32 -9e -T0 >../boot/initramfs.img
