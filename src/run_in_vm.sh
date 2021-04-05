#!/bin/sh

if [ -z "$1" ] || [ -z "$2" ]; then
    echo Usage: $0 vmlinuz initramfs.img
    exit 1
fi

if ! file "$1" | grep -q 'Linux kernel'; then
    echo "$1" should be a Linux kernel image
    exit 1
fi

initramfs_file=$(file "$2")

if (! echo "$initramfs_file" | grep -q 'compressed data') && (! echo "$initramfs_file" | grep cpio)
then
    echo "$2" should be a initramfs image
    exit 1
fi

if [ -n "$3" ]; then
    ARCH="$3"
else
    ARCH=$(arch)
fi

exec qemu-system-"$ARCH" \
    -curses \
    -no-reboot \
    -enable-kvm \
    -cpu host \
    -m 512M \
    -smp $(nproc) \
    -kernel "$1" \
    -initrd "$2"
