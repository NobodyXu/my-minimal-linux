#!/bin/sh

if [ -z "$1" ] || [ -z "$2" ]; then
    echo Usage: $0 vmlinuz initramfs.img
    exit 1
fi

if [ -n "$3" ]; then
    ARCH="$3"
else
    ARCH=$(arch)
fi

exec qemu-system-${ARCH} -nographic -kernel $1 -initrd $2
