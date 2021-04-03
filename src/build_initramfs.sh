#!/bin/sh -ex

cd $(dirname $0)/rootfs/
find . | cpio -o --format='newc' | xz -9e -T0 >../boot/initramfs.img
